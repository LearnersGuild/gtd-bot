require 'rails_helper'

describe TeamsMatcher do
  let(:matcher) do
    TeamsMatcher.new(glass_frog_client, asana_client, team_object_factory)
  end
  let(:glass_frog_client) do
    instance_double('GlassFrogClient', circles: circles)
  end
  let(:asana_client) do
    instance_double('AsanaClient', teams: teams)
  end
  let(:team_object_factory) do
    instance_double('TeamObjectFactory')
  end

  describe "#perform" do
    subject { matcher.perform }

    let(:circle1) { TeamObject.new(name: 'Team1') }
    let(:circle2) { TeamObject.new(name: 'Team2') }
    let(:team1) { TeamObject.new(name: 'Team1') }
    let(:team2) { TeamObject.new(name: 'Team2') }
    let(:circles) { [circle1, circle2] }
    let(:teams) { [team1, team2] }

    it "returns matched teams" do
      expect(team_object_factory).to receive(:build_merged)
        .with(circle1, team1).and_return(team1)
      expect(team_object_factory).to receive(:build_merged)
        .with(circle2, team2).and_return(team2)
      expect(subject).to eq([team1, team2])
    end

    context "team not found" do
      let(:team2) { TeamObject.new(name: 'Wrong name') }

      it "skips teams that does not match name" do
        expect(team_object_factory).to receive(:build_merged)
          .with(circle1, team1).and_return(team1)
        expect(subject).to eq([team1])
      end
    end
  end
end
