require "spec_helper"
require "outcome_resolver"
require "support"

describe OutcomeResolver do
  let(:client) do
    TestServiceClient.new
  end

  context "all outcomes are covered" do

    before do
      client.use_service_correctly(true, true)
    end

    it "sets flash values correctly" do
      expect(client.flash[:signin]).to be(true)
    end

    it "sets flag value correctly" do
      expect(client.flag).to be(true)
    end
  end

  context "not all outcomes are covered" do
    it "raises an exception" do
      expect(client.use_service_incorrectly(true, true)).to be(true)
    end
  end

end
