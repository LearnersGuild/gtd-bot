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
      ProjectObject.new(name: "@Project"),
      ProjectObject.new(name: "@Role")
    ]
  end

  describe '#perform' do
    it 'changes illegal names' do
      expect(asana_client).to receive(:update_project).once
      subject
    end
  end
end
