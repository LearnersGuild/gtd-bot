require 'rails_helper'

describe ProjectObjectFactory do
  let(:project_object_factory) { ProjectObjectFactory.new }
  describe '#build_from_asana' do
    subject { project_object_factory.build_from_asana(project) }
    let(:project) do
      double(
        id: id,
        name: name,
        owner: owner,
        notes: notes
      )
    end
    let(:id) { '1' }
    let(:name) { 'name' }
    let(:owner) { { "id" => owner_id } }
    let(:owner_id) { '2' }
    let(:notes) { 'description' }
    let(:expected_project_object) do
      ProjectObject.new(
        asana_id: id,
        name: name,
        owner_id: owner_id,
        description: notes
      )
    end

    it 'returns project object' do
      expect(subject).to eq(expected_project_object)
    end

    context "owner is blank" do
      let(:owner) { nil }

      let(:expected_project_object) do
        ProjectObject.new(
          asana_id: id,
          name: name,
          owner_id: nil,
          description: notes
        )
      end

      it 'returns project object' do
        expect(subject).to eq(expected_project_object)
      end
    end
  end
end
