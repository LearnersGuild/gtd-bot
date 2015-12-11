require 'rails_helper'

describe IllegalRolesRenamer do
  subject do
    IllegalRolesRenamer.new(projects_repository)
      .perform(exisiting_roles, roles_from_asana)
  end
  let(:projects_repository) { double('ProjectsRepository') }
  let(:exisiting_roles) { [RoleObject.new(name: 'Role')] }
  let(:roles_from_asana) do
    [
      ProjectObject.new(name: "&Role"),
      ProjectObject.new(name: ProjectObject::INDIVIDUAL_ROLE),
      project_to_rename
    ]
  end
  let(:project_to_rename) { ProjectObject.new(asana_id: 1, name: "&Project") }

  describe '#perform' do
    it 'changes illegal names' do
      expect(projects_repository).to receive(:update)
        .with(project_to_rename, name: "_Project")
      subject
    end
  end
end
