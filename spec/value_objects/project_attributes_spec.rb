require 'rails_helper'

describe ProjectAttributes do
  describe "#initialize" do
    subject { ProjectAttributes.new('NewRole') }

    it "returns hash with attributes" do
      expect(subject).to eq(
        workspace: A9n.asana[:workspace_id],
        team: A9n.asana[:team_id],
        name: "NewRole"
      )
    end
  end
end
