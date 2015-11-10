module Strategies
  describe SyncRole do
    subject do
      SyncRole.new(glass_frog_client, asana_roles_updater,
                   roles_diff_factory, roles_saver, role_object_factory)
    end

    let(:glass_frog_client) { instance_double('GlassFrogClient', roles: roles) }
    let(:asana_roles_updater) do
      instance_double('AsanaRolesUpdater', perform: updated_diff)
    end
    let(:roles_diff_factory) { double(:roles_diff_factory, new: roles_diff) }
    let(:roles_diff) { instance_double('RolesDiff', perform: diff) }
    let(:roles_saver) { instance_double('RolesSaver', perform: true) }
    let(:role_object_factory) { instance_double('RoleObjectFactory') }
    let(:roles) { double(:roles) }
    let(:diff) { double(:diff) }
    let(:updated_diff) { double(:updated_diff) }

    describe "#perform" do
      it "syncs Asana roles with Glass Frog" do
        expect(glass_frog_client).to receive(:roles)
        expect(roles_diff).to receive(:perform)
        expect(asana_roles_updater).to receive(:perform).with(diff)
        expect(roles_saver).to receive(:perform).with(updated_diff)

        subject.perform
      end
    end
  end
end
