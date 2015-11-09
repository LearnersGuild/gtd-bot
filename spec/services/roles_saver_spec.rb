require 'rails_helper'

describe RolesSaver do
  let(:role_saver) { RolesSaver.new }

  describe "#perform" do
    subject { role_saver.perform(diff) }

    let(:diff) do
      { to_create: [glass_frog_role] }
    end
    let(:glass_frog_role) do
      RoleObject.new(
        glass_frog_id: 7,
        name: 'Awesome Developer',
        asana_id: "7777"
      )
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
    end
  end
end
