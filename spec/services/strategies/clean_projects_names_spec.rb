require 'rails_helper'

module Strategies
  describe CleanProjectsNames do
    let(:strategy) do
      CleanProjectsNames.new(projects_repository, team,
                             illegal_roles_renamer_factory, roles_repository)
    end
    let(:projects_repository) do
      double('ProjectsRepository', roles: projects_from_asana)
    end
    let(:projects_from_asana) do
      [
        ProjectObject.new(name: "&Project", asana_id: id),
        ProjectObject.new(name: "&Role")
      ]
    end
    let(:team) do
      TeamObject.new(roles: roles_from_glass_frog)
    end
    let(:roles_repository) do
      instance_double('RolesRepository', for_team: existing_roles)
    end
    let(:existing_roles) { [double(asana_id: id)] }
    let(:id) { '111' }
    let(:roles_from_glass_frog) { [RoleObject.new(name: 'Role')] }
    let(:illegal_roles_renamer_factory) { double(new: illegal_roles_renamer) }
    let(:illegal_roles_renamer) do
      instance_double('IllegalRolesRenamer')
    end

    describe '#perform' do
      subject { strategy.perform }

      it 'cleans improperly named projects' do
        expect(illegal_roles_renamer).to receive(:perform)
          .with(existing_roles, projects_from_asana)
        expect(projects_repository).to receive(:roles)
        subject
      end
    end
  end
end
