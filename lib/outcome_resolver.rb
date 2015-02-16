require "outcome_resolver/version"
require "outcome_resolver/outcome"

require "pry"

# define methods from parameters that are called from the service
# make a singleton carrying all the state the outcomes have been checked
# separate client specific object to record the called methods

module OutcomeResolver

  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def outcomes(*outcomes_hash)

      outcomes = Hash.new
      outcomes_hash.each do |method_name|
        self.class_eval do

          define_method(method_name) do |arg, *payload|
            outcomes[method_name] = [arg, payload]
          end

          define_method(:reset_outcomes) do
            outcomes.each do |key, val|
              outcomes[key] = false
            end
          end

        end

      end

      Outcome.class_eval do
        define_method(:outcomes_hash) do
          outcomes
        end
      end

    end
  end

  module InstanceMethods
    # yield outcome to block to record all actions to be taken in results hash
    # check if all outcomes are covered
    # then perform the matching results
    def resolve_outcome
      yield outcome
      unless outcome.covered_all_cases?
        raise OutcomeHandlingIncomplete, "You have to cover all the specified outcomes"
      end
      outcome.perform
      reset_outcomes
    end

    def outcome
      @outcome ||= Outcome.new
    end

    class OutcomeHandlingIncomplete < StandardError
    end

  end

end
