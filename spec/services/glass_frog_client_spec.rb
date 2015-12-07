require 'rails_helper'

describe GlassFrogClient do
  let(:glass_frog_client) do
    GlassFrogClient.new(team_object_factory, role_object_factory)
  end
  let(:team_object_factory) { instance_double('TeamObjectFactory') }
  let(:role_object_factory) { instance_double('RoleObjectFactory') }

  describe "#circles" do
    let(:circle) { double(:circle) }

    it "delegates to Glassfrog client" do
      expect(glass_frog_client).to respond_to(:circles)
    end

    it "maps roles to RoleObjects" do
      glass_frog_client.client = double(get: [circle])
      expect(team_object_factory).to receive(:from_glass_frog).with(circle)
      glass_frog_client.circles
    end
  end

  describe "#roles" do
    let(:role) { double(:role) }

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
