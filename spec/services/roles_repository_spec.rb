require 'rails_helper'

describe RolesRepository do
  let(:repository) { RolesRepository.new }

  describe "#existing_without_individual" do
    let(:team) { TeamObject.new(asana_id: '1111') }

    subject { repository.existing_without_individual(team) }

    it { expect(subject).to eq([]) }

    context "exists in db" do
      let!(:existing) { create(:role, asana_team_id: '1111') }
      let!(:existing_in_different_team) { create(:role, asana_team_id: '2222') }

      it { expect(subject).to eq([existing]) }

      context 'does not return Individual roles' do
        let!(:individual) do
          create(:role, name: 'Individual', asana_team_id: '1111')
        end

        it { expect(subject).to eq([existing]) }
      end
    end
  end
end
