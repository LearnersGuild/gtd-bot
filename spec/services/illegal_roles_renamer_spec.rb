require 'rails_helper'

describe IllegalRolesRenamer do
  subject do
    IllegalRolesRenamer.new(asana_client)
      .perform(roles_from_glass_frog, roles_from_asana)
  end
  let(:asana_client) { instance_double('AsanaClient') }
  let(:roles_from_glass_frog) { [RoleObject.new(name: 'Role')] }
  let(:roles_from_asana) do
    [
      ProjectObject.new(name: "&Role"),
      ProjectObject.new(name: ProjectObject::INDIVIDUAL_NAME),
      project_to_rename
    ]
  end
  let(:project_to_rename) { ProjectObject.new(asana_id: 1, name: "&Project") }

  describe '#perform' do
    it 'changes illegal names' do
      expect(asana_client).to receive(:update_project)
        .with(project_to_rename.asana_id, name: "_Project")
      subject
    end
  end
end
