require 'rails_helper'

describe UserObjectFactory do
  let(:factory) { UserObjectFactory.new }
  let(:glass_frog_user) do
    UserObject.new(
      email: 'test@test.com',
      glass_frog_id: 7
    )
  end
  let(:asana_user) do
    UserObject.new(
      email: 'test@test.com',
      asana_id: '7777'
    )
  end

  describe "#merge_users" do
    subject { factory.merge_users(glass_frog_users, asana_users) }
    let(:glass_frog_users) { [glass_frog_user] }
    let(:asana_users) { [asana_user] }

    it "returns merged users" do
      merged = double(:merged)
      expect(asana_user).to receive(:matches?).and_return(true)
      expect(factory).to receive(:build_merged)
        .with(asana_user, glass_frog_user)
        .and_return(merged)

      expect(subject).to eq([merged])
    end

    context "asana user not found" do
      it "does not include user" do
        expect(asana_user).to receive(:matches?).and_return(false)
        expect(factory).not_to receive(:build_merged)

        expect(subject).to eq([])
      end
    end
  end

  describe "#build_merged" do
    subject { factory.build_merged(asana_user, glass_frog_user) }

    it "returns merged user" do
      expected_user = UserObject.new(
        email: asana_user.email,
        asana_id: asana_user.asana_id,
        glass_frog_id: glass_frog_user.glass_frog_id
      )
      expect(subject).to eq(expected_user)
    end
  end
end
