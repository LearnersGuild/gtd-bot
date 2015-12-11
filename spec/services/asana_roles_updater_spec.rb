require 'rails_helper'

describe AsanaRolesUpdater do
  let(:updater) { AsanaRolesUpdater.new(projects_repository) }
  let(:projects_repository) do
    instance_double(
      'ProjectsRepository',
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
  let(:role) do
    RoleObject.new(
      glass_frog_id: 7,
      name: 'Role',
      asana_team_id: team_id
    )
  end
  let(:role_attributes) { role.attributes }
  let(:team_id) { '1111' }

  describe "#perform" do
    subject { updater.perform(diff) }

    context "to_create" do
      let(:diff) do
        { to_create: [role] }
      end

      it "updates repository" do
        role_attributes = double(:role_attributes)
        expect(role).to receive(:role_attributes).and_return(role_attributes)
        expect(projects_repository).to receive(:create)
          .with(team_id, role_attributes)
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
      let(:existing_role) do
        RoleObject.new(
          glass_frog_id: 7,
          name: 'Role',
          asana_id: '7777',
          asana_team_id: team_id
        )
      end
      let(:role_attributes) { existing_role.attributes }

      context "to_delete" do
        let(:diff) do
          { to_delete: [existing_role] }
        end

        it "updates repository" do
          expect(projects_repository).to receive(:delete)
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
          { to_update: [to_update_from_glass_frog] }
        end
        let(:to_update_from_glass_frog) do
          RoleObject.new(role_attributes.merge(name: 'Role2'))
        end

        it "updates repository" do
          role_attributes = double(:role_attributes)
          expect(to_update_from_glass_frog).to receive(:role_attributes)
            .and_return(role_attributes)
          expect(projects_repository).to receive(:update)
            .with(ProjectObject.new(asana_id: '7777'), role_attributes)
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
