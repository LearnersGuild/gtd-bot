require 'rails_helper'

module Strategies
  describe CleanProjectsNames do
    let(:strategy) do
      CleanProjectsNames.new(projects_collection, team,
                             illegal_roles_renamer)
    end
    let(:projects_collection) do
      instance_double('ProjectsCollection', roles: projects_from_asana)
    end
    let(:projects_from_asana) do
      [
        ProjectObject.new(name: "&Project"),
        ProjectObject.new(name: "&Role")
      ]
    end
    let(:team) do
      TeamObject.new(roles: roles_from_glass_frog)
    end
    let(:roles_from_glass_frog) { [RoleObject.new(name: 'Role')] }
    let(:illegal_roles_renamer) do
      instance_double('IllegalRolesRenamer')
    end

    describe '#perform' do
      subject { strategy.perform }
      it 'cleans improperly named projects' do
        expect(illegal_roles_renamer).to receive(:perform)
          .with(roles_from_glass_frog, projects_from_asana)
        subject
      end
    end
  end
end
