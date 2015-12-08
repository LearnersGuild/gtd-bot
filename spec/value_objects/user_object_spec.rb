require 'rails_helper'

describe UserObject do
  let(:user) { UserObject.new(email: 'user@example.org') }

  describe "#matches?" do
    subject { user.matches?(other) }

    let(:other) { UserObject.new(email: 'other@example.org') }

    it { expect(subject).to be false }

    context "matches" do
      let(:other) { UserObject.new(email: 'user@example.org') }

      it { expect(subject).to be true }
    end
  end
end
