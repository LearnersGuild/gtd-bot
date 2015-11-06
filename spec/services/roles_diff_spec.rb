require 'rails_helper'

describe RolesDiff do
  let(:roles) do
    [role_to_create, role_to_update]
  end
  let(:roles_diff) { RolesDiff.new(roles) }

  describe "#perform" do
    subject { roles_diff.perform }

    let(:role_to_create) { double(id: 8, name: 'Awesome Developer') }
    let!(:role_to_delete) { create(:role) }
    let(:role_to_update) { double(id: existing_id, name: 'New name') }
    let(:existing_id) { 7 }

    before(:each) do
      create(:role, glass_frog_id: existing_id)
    end

    it "returns roles to create" do
      expect(subject[:to_create]).to eq([role_to_create])
    end

    it "returns roles to delete" do
      expect(subject[:to_delete]).to eq([role_to_delete])
    end

    it "returns roles to update" do
      expect(subject[:to_update]).to eq([role_to_update])
    end
  end
end
