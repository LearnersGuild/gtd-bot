require 'rails_helper'

describe AsanaRolesUpdater do
  let(:updater) { AsanaRolesUpdater.new(asana_client) }
  let(:asana_client) do
    instance_double('AsanaClient',
                    create_project: project,
                    delete_project: true)
  end
  let(:project) { double(:project, id: 7777) }
  let(:role_attributes) { { glass_frog_id: 7, name: 'Role' } }

  describe "#perform" do
    subject { updater.perform(diff) }

    context "to_create" do
      let(:diff) do
        { to_create: [RoleObject.new(role_attributes)] }
      end

      it "returns diff with updated Asana ids" do
        expected_attributes = role_attributes.merge(asana_id: 7777)
        expect(subject).to eq(
          to_create: [RoleObject.new(expected_attributes)],
          to_delete: []
        )
      end
    end

    context "to_delete" do
      let(:diff) do
        { to_delete: [RoleObject.new(role_attributes)] }
      end
      let(:role_attributes) do
        { glass_frog_id: 7, name: 'Role', asana_id: 7777 }
      end

      it "returns diff with updated Asana ids" do
        expect(subject).to eq(
          to_create: [],
          to_delete: [RoleObject.new(role_attributes)]
        )
      end
    end
  end
end
