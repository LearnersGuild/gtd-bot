require 'rails_helper'

describe SubtaskObjectFactory do
  let(:subtask_object_factory) { SubtaskObjectFactory.new }
  describe '#build_from_asana' do
    subject { subtask_object_factory.build_from_asana(subtask) }
    let(:subtask) do
      double(
        id: id,
        name: name,
        assignee: assignee,
        completed: completed
      )
    end
    let(:id) { '1' }
    let(:name) { 'name' }
    let(:assignee) { { "id" => assignee_id } }
    let(:assignee_id) { '2' }
    let(:completed) { true }
    let(:expected_subtask_object) do
      SubtaskObject.new(
        asana_id: id,
        name: name,
        assignee_id: assignee_id,
        completed: completed
      )
    end

    it 'returns subtask object' do
      expect(subject).to eq(expected_subtask_object)
    end

    context "assignee is blank" do
      let(:assignee) { nil }

      let(:expected_subtask_object) do
        SubtaskObject.new(
          asana_id: id,
          name: name,
          assignee_id: nil,
          completed: completed
        )
      end

      it 'returns subtask object' do
        expect(subject).to eq(expected_subtask_object)
      end
    end
  end
end
