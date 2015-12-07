require 'rails_helper'

describe CirclesFetcher do
  let(:fetcher) { CirclesFetcher.new(glass_frog_client) }
  let(:glass_frog_client) do
    instance_double('GlassFrogClient', circles: [circle], roles: [role])
  end
  let(:circle) { TeamObject.new(roles: [RoleObject.new(glass_frog_id: 7)]) }
  let(:role) do
    RoleObject.new(
      glass_frog_id: 7,
      purpose: 'Purpose',
      domains: [DomainObject.new(description: 'Domain')],
      accountabilities: [AccountabilityObject.new(
        description: 'Accountability')]
    )
  end

  describe "#perform" do
    subject { fetcher.perform }

    it "mapps detailed roles to circles" do
      expect(subject.first.roles).to eq([role])
    end
  end
end
