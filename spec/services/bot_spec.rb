require 'rails_helper'

describe Bot do
  subject { Bot.new(strategies, exception_handler) }

  let(:exception_handler) { instance_double('ExceptionHandler') }

  let(:strategies) { [strategy] }
  let(:strategy) { double(:strategy, perform_with_logging: nil) }

  describe "#perform" do
    it "has method perform" do
      expect(subject).to respond_to(:perform)
    end

    it "performs strategies" do
      expect(strategy).to receive(:perform_with_logging)
      subject.perform
    end
  end
end
