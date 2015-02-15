require "outcome_resolver"

class TestService

  include OutcomeResolver
  # class macro outcomes takes a hash of outcomes and boolean flags and passes it
  # to each instance of the outcome class
  outcomes [:condition_valid, :something_occurred, :user_signed_in]

  def sign_in_user(boolean)
    user_signed_in(true)
  end

  def make_something_occurr
    something_occurred(true)
  end

# instead of early return we implement small utility method
# and set instance variables flags to indicate the outcome of
# an action within the method where the oucome is handled


end

class TestServiceClient

    attr_accessor :flag, :flash

    def initialize
      @flag = false
      @flash = {}
    end

    def use_service_correctly(user_signed_in, condition)
      # invoke all the work-horse methods first
      # then handle their outcomes
      service = TestService.new
      service.sign_in_user(user_signed_in)
      service.make_something_occurr
      service.condition_valid(condition)
      service.resolve_outcome do |outcome|
        outcome
        .when :condition_valid do
          @flag = true
        end
        .when :something_occurred do
          @flash[:occurence] = true
        end
        .when :user_signed_in do
          @flash[:signin] = true
        end
      end

    end

    def use_service_incorrectly(user_signed_in, condition)
      # invoke all the work-horse methods first
      # then handle their outcomes
      service = TestService.new
      service.sign_in_user(user_signed_in)
      service.make_something_occurr
      service.condition_valid(condition)
      service.resolve_outcome do |outcome|
        outcome
        .when :condition_valid do
          @flag = true
        end
        .when :something_occurred do
          @flash[:occurence] = true
        end
      end
    end
end
