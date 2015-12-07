require 'rails_helper'

describe RoleObject do
  let(:role_object) { RoleObject.new(name: 'RoleName', purpose: "Purpose") }

  describe "#name_with_prefix" do
    subject { role_object.name_with_prefix }

    it { expect(subject).to eq("&RoleName") }
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
          description: 'Accountability')]
      )
    end

    it "returns name with prefix and description" do
      expected_description =
        "Purpose: Purpose\nDomains: Domain\nAccountabilities: Accountability"
      expect(subject).to eq(
        name: '&RoleName',
        notes: expected_description
      )
    end

    context "empty role" do
      let(:role_object) { RoleObject.new(name: 'RoleName') }

      it "returns name with prefix and description" do
        expect(subject).to eq(
          name: '&RoleName',
          notes: "Purpose: \nDomains: \nAccountabilities: "
        )
      end
    end
  end
end
