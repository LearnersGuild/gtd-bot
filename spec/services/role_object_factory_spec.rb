require 'rails_helper'

describe RoleObjectFactory do
  let(:factory) do
    RoleObjectFactory.new(role_links_factory, user_object_factory)
  end
  let(:role_links_factory) { RoleLinksFactory.new }
  let(:user_object_factory) do
    instance_double('UserObjectFactory',
                    from_db: user_object_from_db,
                    from_glass_frog: user_object)
  end
  let(:user_object) { double(:user_object) }
  let(:user_object_from_db) { double(:user_object_from_db) }

  describe "#from_db" do
    subject { factory.from_db(role) }

    let(:role) do
      create(
        :role,
        accountabilities: [accountability_attributes],
        domains: [domain_attributes],
        users: [user_attributes]
      )
    end
    let(:accountability_attributes) { { description: 'Accountability' } }
    let(:domain_attributes) { { description: 'Domain' } }
    let(:user_attributes) do
      {
        'email' => 'user@example.org',
        'glass_frog_id' => 7,
        'asana_id' => '7777'
      }
    end

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
    it do
      expect(user_object_factory).to receive(:from_db)
        .with(user_attributes)
      expect(subject.users).to eq([user_object_from_db])
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
        domains: domains,
        people: users
      )
    end
    let(:accountabilities) { [double(description: 'Accountability')] }
    let(:domains) { [double(description: 'Domain')] }
    let(:users) { [glass_frog_user] }
    let(:glass_frog_user) { double(:glass_frog_user) }

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
    it do
      expect(user_object_factory).to receive(:from_glass_frog)
        .with(glass_frog_user)
      expect(subject.users).to eq([user_object])
    end

    context "accountabilities or domains blank" do
      let(:accountabilities) { nil }
      let(:domains) { nil }
      let(:users) { nil }

      it { expect(subject.accountabilities).to eq([]) }
      it { expect(subject.domains).to eq([]) }
      it { expect(subject.users).to eq([]) }
    end
  end
end

