require 'rails_helper'

describe RolesSaver do
  let(:role_saver) { RolesSaver.new }

  describe "#perform" do
    subject { role_saver.perform(diff) }

    let(:role_object) do
      RoleObject.new(
        glass_frog_id: 7,
        name: 'Awesome Developer',
        asana_id: "7777",
        asana_team_id: "1111",
        purpose: "Purpose",
        accountabilities: [AccountabilityObject.new(
          description: "Accountability")],
        domains: [DomainObject.new(description: "Domain")]
      )
    end

    shared_examples_for "saving data corectly" do
      it "populates roles with data from Glass Frog" do
        subject
        role = Role.first

        expect(role.glass_frog_id).to eq(7)
        expect(role.name).to eq('Awesome Developer')
        expect(role.asana_id).to eq('7777')
        expect(role.asana_team_id).to eq('1111')
        expect(role.purpose).to eq('Purpose')
        expect(role.accountabilities.first).to eq(
          'description' => 'Accountability')
        expect(role.domains.first).to eq('description' => 'Domain')
      end
    end

    context "to_create" do
      let(:diff) do
        { to_create: [role_object] }
      end

      it "saves roles to db" do
        expect { subject }.to change { Role.count }.from(0).to(1)
      end

      it_behaves_like "saving data corectly"
    end

    context "to_update" do
      let(:diff) do
        { to_update: [role_object] }
      end
      let!(:db_role) do
        create(
          :role,
          glass_frog_id: 7,
          name: 'Awesome Developer',
          asana_id: "7777",
          asana_team_id: "1111",
          purpose: "Old Purpose",
          accountabilities: [AccountabilityObject.new(
            description: "Old Accountability")],
          domains: [DomainObject.new(description: "Old Domain")]
        )
      end

      it_behaves_like "saving data corectly"
    end

    context "to_delete" do
      let(:diff) do
        { to_delete: [role_object] }
      end

      before(:each) do
        create(:role)
        create(:role, asana_id: "7777")
      end

      it "removes roles to db" do
        expect { subject }.to change { Role.count }.from(2).to(1)
      end

      it "removes specified roles from db" do
        subject
        expect(Role.where(asana_id: "7777")).not_to exist
      end
    end
  end
end
