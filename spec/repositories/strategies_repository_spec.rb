require 'rails_helper'

describe StrategiesRepository do
  let(:repository) { StrategiesRepository.new }

  let(:strategy) { double(class: 'Strategy') }
  let(:resource) { double(asana_id: '7777') }

  describe "#already_performed?" do
    subject { repository.already_performed?(strategy, resource) }

    it { expect(subject).to be false }

    context "strategy already performed" do
      before { repository.register_performing(strategy, resource) }

      it { expect(subject).to be true }

      context "strategy not yet performed on this resource" do
        subject { repository.already_performed?(strategy, other_resource) }

        let(:other_resource) { double(asana_id: '8888') }

        it { expect(subject).to be false }
      end
    end
  end
end
