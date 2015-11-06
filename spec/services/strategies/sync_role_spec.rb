module Strategies
  describe SyncRole do
    subject { SyncRole.new(glass_frog, asana, roles_diff_factory, roles_saver) }

    let(:glass_frog) { instance_double('GlassFrog', roles: roles) }
    # TODO: make it instance_double after implementing
    let(:asana) { double(:asana, update: true) }
    let(:roles_diff_factory) { double(:roles_diff_factory, new: roles_diff) }
    let(:roles_diff) { instance_double('RolesDiff', perform: diff) }
    let(:roles_saver) { instance_double('RolesSaver', perform: true) }
    let(:roles) { double(:roles) }
    let(:diff) { double(:diff) }

    describe "#perform" do
      it "syncs Asana roles with Glass Frog" do
        expect(glass_frog).to receive(:roles)
        expect(roles_diff).to receive(:perform)
        expect(asana).to receive(:update).with(diff)
        expect(roles_saver).to receive(:perform).with(roles)

        subject.perform
      end
    end
  end
end
