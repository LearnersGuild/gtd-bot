require 'rails_helper'

describe RolesRepository do
  let(:repository) { RolesRepository.new }

  describe "#all" do
    subject { repository.all }

    let!(:all_roles) { [create(:role)] }

    it { expect(subject).to eq(all_roles) }
  end

  describe "#existing_without_special" do
    let(:team) { TeamObject.new(asana_id: '1111') }

    subject { repository.existing_without_special(team) }

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

      context 'does not return Everyone roles' do
        let!(:everyone) do
          create(:role, name: 'Everyone', asana_team_id: '1111')
        end

        it { expect(subject).to eq([existing]) }
      end
    end
  end

  describe "#for_team" do
    subject { repository.for_team(team) }

    let(:team) { TeamObject.new(asana_id: '1111') }

    it { expect(subject).to eq([]) }

    context 'exists id db' do
      let!(:existing) { create(:role, asana_team_id: '1111') }
      let!(:existing_special) do
        create(:role, asana_team_id: '1111', name: 'Individual')
      end
      let!(:existing_in_different_team) { create(:role, asana_team_id: '2222') }

      it { expect(subject).to eq([existing, existing_special]) }
    end
  end

  describe "#create_from" do
    subject { repository.create_from(project, team) }
    let(:project) do
      ProjectObject.new(
        name: 'Project',
        asana_id: '7777'
      )
    end
    let(:team) { TeamObject.new(asana_id: '8888') }

    it 'creates role in DB' do
      subject
      role = Role.where(
        name: project.name,
        asana_id: '7777',
        asana_team_id: '8888'
      )
      expect(role).not_to be_blank
    end
  end
end
