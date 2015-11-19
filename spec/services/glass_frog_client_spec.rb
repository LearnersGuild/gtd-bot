require 'rails_helper'

describe GlassFrogClient do
  let(:glass_frog_client) { GlassFrogClient.new(team_object_factory) }
  let(:team_object_factory) { instance_double('TeamObjectFactory') }
  let(:circle) { double(:circle) }

  describe "#circles" do
    it "delegates to Glassfrog client" do
      expect(glass_frog_client).to respond_to(:circles)
    end

    it "maps roles to RoleObjects" do
      glass_frog_client.client = double(get: [circle])
      expect(team_object_factory).to receive(:from_glass_frog).with(circle)
      glass_frog_client.circles
    end
  end
end
