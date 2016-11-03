require 'rails_helper'

describe RoleObject do
  let(:role_object) { RoleObject.new(name: 'RoleName', purpose: "Purpose") }
  let(:holacracy_role_object) { RoleObject.new(name: "Lead Link", glass_frog_circle_name: "Circle") }

  describe "#name_with_prefix" do
    subject { role_object.name_with_prefix }

    it { expect(subject).to eq("&RoleName") }
  end

  describe "#holacracy_role?" do

    context "Role is a holacracy role" do
      subject { holacracy_role_object.holacracy_role? }
      it { expect(subject).to eq(true) }
    end

    context "Role is not a holacracy role" do
      subject { role_object.holacracy_role? }
      it { expect(subject).to eq(false) }
    end
  end

  describe "#asana_name" do

    context "Role is a holacracy role" do
      subject { holacracy_role_object.asana_name }
      it { expect(subject).to eq("&Lead Link Circle") }
    end

    context "Role is not a holacracy role" do
      subject { role_object.asana_name }
      it { expect(subject).to eq("&RoleName") }
    end
  end

  describe "#==" do
    let(:other) { RoleObject.new(name: "RoleName", purpose: "Purpose") }

    it { expect(role_object).to eq(other) }

    context "not equal" do
      let(:other) { RoleObject.new(name: "RoleName", purpose: "Different") }

      it { expect(role_object).not_to eq(other) }
    end
  end

  describe "#role_attributes" do
    subject { role_object.role_attributes }

    let(:role_object) do
      RoleObject.new(
        name: 'RoleName',
        purpose: "Purpose",
        domains: [DomainObject.new(description: 'Domain')],
        accountabilities: [AccountabilityObject.new(
          description: 'Accountability')],
        users: [user]
      )
    end
    let(:user) { UserObject.new(asana_id: '7777', email: 'test@test.pl') }

    it "returns name with prefix and description" do
      expected_description =
        "Purpose:\nPurpose\n\n" \
        "Domains:\nDomain\n\n" \
        "Accountabilities:\nAccountability\n\n" \
        "Users:\ntest@test.pl"
      expect(subject).to eq(
        name: '&RoleName',
        notes: expected_description,
        owner: user.asana_id
      )
    end

    context "empty role" do
      let(:role_object) { RoleObject.new(name: 'RoleName') }

      it "returns name with prefix and description" do
        expect(subject).to eq(
          name: '&RoleName',
          notes: "Purpose:\n\n\nDomains:\n\n\nAccountabilities:\n\n\nUsers:\n",
          owner: nil
        )
      end
    end
  end
end
