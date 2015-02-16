class Outcome
  attr_accessor :outcomes_hash
  def initialize()
    @covered_cases = []
    @results = {}
    @outcomes_hash = {}
  end

  def covered_all_cases?
    @covered_cases.to_set == outcomes_hash.keys.to_set
  end

  def when(outcome_name, &block)
    @covered_cases << outcome_name

    if outcomes_hash[outcome_name][0]
      payload = outcomes_hash[outcome_name][1]
      @results[outcome_name] = [block, payload]
    end
    self
  end

  def perform
    @results.each do |result, block_with_payload|
      block = block_with_payload[0]
      payload = block_with_payload[1]
      block.call(*payload)
    end
  end
end
