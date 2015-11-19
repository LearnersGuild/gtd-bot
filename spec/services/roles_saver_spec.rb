require 'rails_helper'

describe RolesSaver do
  let(:role_saver) { RolesSaver.new }

  describe "#perform" do
    subject { role_saver.perform(diff) }
    let(:role_object) do
      RoleObject.new(
        glass_frog_id: 7,
        name: 'Awesome Developer',
        asana_id: "7777",
        asana_team_id: "1111"
      )
    end

    context "to_create" do
      let(:diff) do
        { to_create: [role_object] }
      end

      it "saves roles to db" do
        expect { subject }.to change { Role.count }.from(0).to(1)
      end

      it "populates roles with data from Glass Frog" do
        subject
        role = Role.first

        expect(role.glass_frog_id).to eq(7)
        expect(role.name).to eq('Awesome Developer')
        expect(role.asana_id).to eq('7777')
        expect(role.asana_team_id).to eq('1111')
      end
    end

    context "to_delete" do
      let(:diff) do
        { to_delete: [role_object] }
      end

      before(:each) do
        create(:role)
        create(:role, asana_id: "7777")
      end

      it "removes roles to db" do
        expect { subject }.to change { Role.count }.from(2).to(1)
      end

      it "removes specified roles from db" do
        subject
        expect(Role.where(asana_id: "7777")).not_to exist
      end
    end
  end
end
