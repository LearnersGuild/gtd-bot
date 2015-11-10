require 'rails_helper'

describe Bot do
  subject { Bot.new(strategies) }

  let(:strategies) { [strategy] }
  let(:strategy) { double(:strategy, perform: nil) }

  describe "#perform" do
    it "has method perform" do
      expect(subject).to respond_to(:perform)
    end

    it "performs strategies" do
      expect(strategy).to receive(:perform)
      subject.perform
    end
  end
end
