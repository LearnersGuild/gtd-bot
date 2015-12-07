require 'rails_helper'

describe TeamObjectFactory do
  let(:factory) { TeamObjectFactory.new(role_object_factory) }
  let(:role_object_factory) do
    instance_double('RoleObjectFactory', from_glass_frog: role)
  end
  let(:role) { double(:role) }

  describe "#from_glass_frog" do
    subject { factory.from_glass_frog(circle) }

    let(:circle) do
      double(:circle, id: id, short_name: short_name, roles: roles)
    end
    let(:id) { '1111' }
    let(:short_name) { 'Short name' }
    let(:roles) { [role] }

    it "returns team object build properly" do
      expect(role_object_factory).to receive(:from_glass_frog).with(role)
      expected = TeamObject.new(
        glass_frog_id: id,
        name: short_name,
        roles: roles
      )
      expect(subject).to eq(expected)
    end
  end

  describe "#from_asana" do
    subject { factory.from_asana(team) }

    let(:team) { double(:team, id: id, name: name, users: [user]) }
    let(:user) { double(:user, id: '111', name: "Test") }
    let(:id) { '1111' }
    let(:name) { 'Short name' }

    it "returns team object build properly" do
      expected = TeamObject.new(
        asana_id: id,
        name: name,
        users: [user.id]
      )
      expect(subject).to eq(expected)
    end
  end

  describe "#build_merged" do
    subject { factory.build_merged(circle, team) }

    let(:circle) do
      TeamObject.new(name: name, glass_frog_id: glass_frog_id, roles: [role])
    end
    let(:team) do
      TeamObject.new(name: name, asana_id: asana_id)
    end
    let(:name) { 'Short name' }
    let(:asana_id) { '1111' }
    let(:glass_frog_id) { '2222' }
    let(:role) { RoleObject.new }

    it "merges data from Asana to the one from GF" do
      expected = TeamObject.new(
        name: name,
        asana_id: asana_id,
        glass_frog_id: glass_frog_id,
        roles: [RoleObject.new(asana_team_id: asana_id)]
      )
      expect(subject).to eq(expected)
    end
  end
end
