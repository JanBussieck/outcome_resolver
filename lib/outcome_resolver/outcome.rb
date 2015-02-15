class Outcome
  attr_accessor :outcomes_hash
  def initialize()
    @covered_cases = []
    @results = {}
    @outcomes_hash = {}
  end

  def covered_all_cases?
    binding.pry
    @covered_cases.to_set == outcomes_hash.keys.to_set
  end

  def when(outcome_name, &block)
    @covered_cases << outcome_name

    if outcomes_hash[outcome_name]
      @results[outcome_name] = block
    end
    self
  end

  def perform
    @results.each do |result, block|
      block.call()
    end
  end
end
