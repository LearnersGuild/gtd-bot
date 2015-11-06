module Strategies
  describe SyncRole do
    subject { SyncRole.new(glass_frog, asana, roles_diff, roles_saver) }
    let(:glass_frog) { double(:glass_frog, roles: roles) }
    let(:asana) { double(:asana, update: true) }
    let(:roles_diff) { double(:roles_diff, diff: diff) }
    let(:roles_saver) { double(:roles_saver, perform: true) }
    let(:roles) { double(:roles) }
    let(:diff) { double(:diff) }

    describe "#perform" do
      it "syncs Asana roles with Glass Frog" do
        expect(glass_frog).to receive(:roles)
        expect(roles_diff).to receive(:diff).with(roles)
        expect(asana).to receive(:update).with(diff)
        expect(roles_saver).to receive(:perform).with(roles)

        subject.perform
      end
    end
  end
end
