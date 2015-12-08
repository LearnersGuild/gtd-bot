require 'rails_helper'

describe RoleObjectFactory do
  let(:factory) { RoleObjectFactory.new }

  describe "#from_db" do
    subject { factory.from_db(role) }

    let(:role) do
      create(:role, accountabilities: [accountability_attributes],
                    domains: [domain_attributes])
    end
    let(:accountability_attributes) { { description: 'Accountability' } }
    let(:domain_attributes) { { description: 'Domain' } }

    it { expect(subject.glass_frog_id).to eq(role.glass_frog_id) }
    it { expect(subject.name).to eq(role.name) }
    it { expect(subject.asana_id).to eq(role.asana_id) }
    it { expect(subject.asana_team_id).to eq(role.asana_team_id) }
    it { expect(subject.purpose).to eq(role.purpose) }
    it do
      expected = [AccountabilityObject.new(accountability_attributes)]
      expect(subject.accountabilities).to eq(expected)
    end
    it do
      expected = [DomainObject.new(domain_attributes)]
      expect(subject.domains).to eq(expected)
    end
  end

  describe "#from_glass_frog" do
    subject { factory.from_glass_frog(role) }

    let(:role) do
      double(
        id: 7,
        name: 'Awesome Developer',
        purpose: 'Purpose',
        accountabilities: accountabilities,
        domains: domains
      )
    end
    let(:accountabilities) { [double(description: 'Accountability')] }
    let(:domains) { [double(description: 'Domain')] }

    it { expect(subject.glass_frog_id).to eq(7) }
    it { expect(subject.name).to eq('Awesome Developer') }
    it { expect(subject.asana_id).to be_nil }
    it { expect(subject.purpose).to eq('Purpose') }
    it do
      expected = [AccountabilityObject.new(description: 'Accountability')]
      expect(subject.accountabilities).to eq(expected)
    end
    it do
      expected = [DomainObject.new(description: 'Domain')]
      expect(subject.domains).to eq(expected)
    end

    context "accountabilities or domains blank" do
      let(:accountabilities) { nil }
      let(:domains) { nil }

      it { expect(subject.accountabilities).to eq([]) }
      it { expect(subject.domains).to eq([]) }
    end
  end
end

