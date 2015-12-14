require 'rails_helper'

describe SubtasksCollection do
  let(:collection) { SubtasksCollection.new(subtasks) }
  let(:subtasks) do
    [
      assigned_subtask,
      unassigned_subtask,
      completed_subtask
    ]
  end
  let(:unassigned_subtask) { SubtaskObject.new(assignee_id: nil) }
  let(:assigned_subtask) { SubtaskObject.new(assignee_id: '111') }
  let(:completed_subtask) { SubtaskObject.new(completed: true) }

  it_behaves_like "BaseCollection", SubtasksCollection, SubtaskObject

  describe '#unassigned' do
    subject { collection.unassigned }
    let(:expected_tasks) { [unassigned_subtask] }

    it 'returns unassigned tasks' do
      expect(subject).to eq(SubtasksCollection.new(expected_tasks))
    end
  end

  describe '#uncompleted_subtasks' do
    subject { collection.uncompleted_subtasks }
    let(:expected_tasks) { subtasks - [completed_subtask] }

    it 'returns unassigned tasks' do
      expect(subject).to eq(SubtasksCollection.new(expected_tasks))
    end
  end
end
