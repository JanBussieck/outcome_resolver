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
    def outcomes(outcomes_hash)
      clean_outcome = Outcome.new
      outcomes_hash.each do |method_name|
        self.class_eval do

          define_method(method_name) do |arg|
            clean_outcome.outcomes_hash[method_name] = arg
          end

        end

      end

      self.class_eval do
        define_method(:outcome) do
          clean_outcome
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
    end

    class OutcomeHandlingIncomplete < StandardError
    end

  end

end
