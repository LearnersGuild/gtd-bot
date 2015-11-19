require 'rails_helper'

describe Bot do
  subject { Bot.new(teams_matcher, strategies_factory, exception_handler) }

  let(:teams_matcher) { instance_double('TeamsMatcher', perform: [team]) }
  let(:team) { TeamObject.new }
  let(:exception_handler) { instance_double('ExceptionHandler') }

  let(:strategies_factory) do
    instance_double('StrategiesFactory', create: [strategy])
  end
  let(:strategy) { double(:strategy, perform_with_logging: nil) }

  describe "#perform" do
    it "has method perform" do
      expect(subject).to respond_to(:perform)
    end

    it "performs strategies" do
      expect(teams_matcher).to receive(:perform)
      expect(strategies_factory).to receive(:create).with(team)
      expect(strategy).to receive(:perform_with_logging)
      subject.perform
    end
  end
end
