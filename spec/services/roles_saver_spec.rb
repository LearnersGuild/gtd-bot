require 'rails_helper'

describe RolesSaver do
  let(:role_saver) { RolesSaver.new }

  describe "#perform" do
    subject { role_saver.perform([glass_frog_role]) }
    let(:glass_frog_role) { double(id: 7, name: 'Awesome Developer') }

    it "saves roles to db" do
      expect { subject }.to change { Role.count }.from(0).to(1)
    end

    it "populates roles with data from Glass Frog" do
      subject
      role = Role.first

      expect(role.glass_frog_id).to eq(7)
      expect(role.name).to eq('Awesome Developer')
    end
  end
end
