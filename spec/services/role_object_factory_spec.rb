require 'rails_helper'

describe RoleObjectFactory do
  let(:factory) { RoleObjectFactory.new }

  describe "#from_db" do
    subject { factory.from_db(role) }

    let(:role) { create(:role) }

    it { expect(subject.glass_frog_id).to eq(role.glass_frog_id) }
    it { expect(subject.name).to eq(role.name) }
    it { expect(subject.asana_id).to eq(role.asana_id) }
  end

  describe "#from_glass_frog" do
    subject { factory.from_glass_frog(role) }

    let(:role) { double(id: 7, name: 'Awesome Developer') }

    it { expect(subject.glass_frog_id).to eq(7) }
    it { expect(subject.name).to eq('Awesome Developer') }
    it { expect(subject.asana_id).to be_nil }
  end
end

