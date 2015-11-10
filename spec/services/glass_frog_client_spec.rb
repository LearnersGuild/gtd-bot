require 'rails_helper'

describe GlassFrogClient do
  let(:glass_frog_client) { GlassFrogClient.new(role_object_factory) }
  let(:role_object_factory) { instance_double('RoleObjectFactory') }
  let(:role) { double(:role) }

  describe "#roles" do
    it "delegates to Glassfrog client" do
      expect(glass_frog_client).to respond_to(:roles)
    end

    it "maps roles to RoleObjects" do
      glass_frog_client.client = double(get: [role])
      expect(role_object_factory).to receive(:from_glass_frog).with(role)
      glass_frog_client.roles
    end
  end
end
