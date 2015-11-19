require 'rails_helper'

describe ProjectAttributes do
  describe "#initialize" do
    subject { ProjectAttributes.new('NewRole', '1111') }

    it "returns hash with attributes" do
      expect(subject).to eq(
        workspace: A9n.asana[:workspace_id],
        team: '1111',
        name: "NewRole"
      )
    end
  end
end
