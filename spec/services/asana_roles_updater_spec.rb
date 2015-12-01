require 'rails_helper'

describe AsanaRolesUpdater do
  let(:updater) { AsanaRolesUpdater.new(asana_client, projects_filter) }
  let(:projects_filter) do
    instance_double(
      'ProjectsCollection',
      create: project_object,
      update: project_object,
      delete: project_object
    )
  end
  let(:asana_client) do
    instance_double('AsanaClient',
                    create_project: project_object,
                    delete_project: project_object,
                    update_project: project_object)
  end
  let(:project_object) do
    ProjectObject.new(role_attributes.merge(asana_id: '7777'))
  end
  let(:role_attributes) do
    { glass_frog_id: 7, name: 'Role', asana_team_id: team_id }
  end
  let(:team_id) { '1111' }

  describe "#perform" do
    subject { updater.perform(diff) }

    context "to_create" do
      let(:diff) do
        { to_create: [RoleObject.new(role_attributes)] }
      end

      it "updates Asana" do
        expect(asana_client).to receive(:create_project)
          .with(ProjectAttributes.new('&Role', team_id))
        subject
      end

      it "updates local cache" do
        expect(projects_filter).to receive(:create).with(project_object)
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
        {
          glass_frog_id: 7,
          name: 'Role',
          asana_id: '7777',
          asana_team_id: team_id
        }
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

        it "updates local cache" do
          expect(projects_filter).to receive(:delete).with(project_object)
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
          { to_update: [to_update_from_glass_frog] }
        end
        let(:to_update_from_glass_frog) do
          RoleObject.new(role_attributes.merge(name: 'Role2'))
        end

        it "updates Asana" do
          expect(asana_client).to receive(:update_project)
            .with('7777', role_attributes.merge(name: '&Role2'))
          subject
        end

        it "updates local cache" do
          expect(projects_filter).to receive(:update).with(project_object)
          subject
        end

        it "returns diff with roles to update" do
          expect(subject).to eq(
            to_create: [],
            to_delete: [],
            to_update: [to_update_from_glass_frog]
          )
        end
      end
    end
  end
end
