require 'rails_helper'

describe RolesDiff do
  let(:roles) do
    [created_in_glass_frog, updated_in_glass_frog]
  end
  let(:role_object_factory) do
    instance_double('RoleObjectFactory')
  end
  let(:existing_roles) { [existing_to_update, existing_to_delete] }
  before(:each) do
    expect(role_object_factory).to receive(:from_db)
      .and_return(existing_to_update, existing_to_delete)
  end
  let(:team_id) { '1111' }

  let(:roles_diff) { RolesDiff.new(roles, existing_roles, role_object_factory) }

  describe "#perform" do
    subject { roles_diff.perform }

    let(:created_in_glass_frog) do
      RoleObject.new(glass_frog_id: 8, name: 'Awesome Developer')
    end
    let(:existing_id) { 7 }
    let(:updated_in_glass_frog) do
      RoleObject.new(
        glass_frog_id: existing_id,
        name: 'New name',
        asana_team_id: team_id
      )
    end
    let!(:existing_to_update) do
      RoleObjectFactory.new.from_db(
        create(:role, glass_frog_id: existing_id, asana_team_id: team_id))
    end
    let!(:existing_to_delete) do
      RoleObjectFactory.new.from_db(
        create(:role, glass_frog_id: 9, asana_team_id: team_id))
    end

    it "returns roles to create" do
      expect(subject[:to_create]).to eq([created_in_glass_frog])
    end

    it "returns roles to delete" do
      expect(subject[:to_delete]).to eq([existing_to_delete])
    end

    it "returns roles to update" do
      expected_attributes =
        updated_in_glass_frog.attributes
        .merge(asana_id: existing_to_update.asana_id)
      expect(subject[:to_update]).to eq([RoleObject.new(expected_attributes)])
    end
  end
end
