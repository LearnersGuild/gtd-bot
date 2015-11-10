require 'rails_helper'

describe AsanaRolesUpdater do
  let(:updater) { AsanaRolesUpdater.new(asana_client) }
  let(:asana_client) do
    instance_double('AsanaClient',
                    create_project: project,
                    delete_project: true,
                    update_project: true)
  end
  let(:project) { double(:project, id: 7777) }
  let(:role_attributes) { { glass_frog_id: 7, name: 'Role' } }

  describe "#perform" do
    subject { updater.perform(diff) }

    context "to_create" do
      let(:diff) do
        { to_create: [RoleObject.new(role_attributes)] }
      end

      it "updates Asana" do
        expect(asana_client).to receive(:create_project)
          .with(ProjectAttributes.new(role_attributes['name']))
        subject
      end

      it "returns diff with roles to create with updated Asana ids" do
        expected_attributes = role_attributes.merge(asana_id: 7777)
        expect(subject).to eq(
          to_create: [RoleObject.new(expected_attributes)],
          to_delete: [],
          to_update: []
        )
      end
    end

    context "existing in db" do
      let(:role_attributes) do
        { glass_frog_id: 7, name: 'Role', asana_id: '7777' }
      end
      let(:existing_role) { RoleObject.new(role_attributes) }

      context "to_delete" do
        let(:diff) do
          { to_delete: [existing_role] }
        end

        it "updates Asana" do
          expect(asana_client).to receive(:delete_project)
            .with('7777')
          subject
        end

        it "returns diff with roles to delete" do
          expect(subject).to eq(
            to_create: [],
            to_delete: [existing_role],
            to_update: []
          )
        end
      end

      context "to_update" do
        let(:diff) do
          { to_update: [existing_role] }
        end

        it "updates Asana" do
          expect(asana_client).to receive(:update_project)
            .with('7777', role_attributes)
          subject
        end

        it "returns diff with roles to update" do
          expect(subject).to eq(
            to_create: [],
            to_delete: [],
            to_update: [existing_role]
          )
        end
      end
    end
  end
end
