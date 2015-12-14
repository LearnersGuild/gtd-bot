require 'rails_helper'

describe TasksCollection do
  let(:collection) { TasksCollection.new(tasks) }
  let(:tasks) do
    [
      assigned_task,
      unassigned_task,
      stale_task,
      forgotten_task,
      completed_task,
      task_with_subtasks
    ]
  end
  let(:assigned_task) { TaskObject.new(assignee_id: assignee_id) }
  let(:unassigned_task) { TaskObject.new(assignee_id: nil) }
  let(:assignee_id) { '1111' }
  let(:stale_task) do
    TaskObject.new(modified_at: TaskObject::STALE_TIME.ago - 1.minute)
  end
  let(:forgotten_task) do
    TaskObject.new(modified_at: TaskObject::STALE_TIME.ago - 1.minute,
                   tags: [TagObject.new(name: 'stale')])
  end
  let(:completed_task) { TaskObject.new(completed: true) }
  let(:task_with_subtasks) { TaskObject.new(subtasks: [SubtaskObject.new]) }

  it_behaves_like "BaseCollection", TasksCollection, TaskObject

  describe '#unassigned' do
    subject { collection.unassigned }
    let(:expected_tasks) do
      [unassigned_task, stale_task, forgotten_task, task_with_subtasks]
    end

    it 'returns unassigned tasks' do
      expect(subject).to eq(TasksCollection.new(expected_tasks))
    end
  end

  describe '#assigned_to' do
    subject { collection.assigned_to(assignee_id) }

    it 'returns unassigned tasks' do
      expect(subject).to eq(TasksCollection.new([assigned_task]))
    end
  end

  describe '#stale_tasks' do
    subject { collection.stale_tasks }

    it 'returns unassigned tasks' do
      expect(subject).to eq(TasksCollection.new([stale_task, forgotten_task]))
    end
  end

  describe '#forgotten_tasks' do
    subject { collection.forgotten_tasks }

    it 'returns unassigned tasks' do
      expect(subject).to eq(TasksCollection.new([forgotten_task]))
    end
  end

  describe '#uncompleted_tasks' do
    subject { collection.uncompleted_tasks }
    let(:expected_tasks) { tasks - [completed_task] }

    it 'returns unassigned tasks' do
      expect(subject).to eq(TasksCollection.new(expected_tasks))
    end
  end

  describe "#with_subtasks" do
    subject { collection.with_subtasks }

    it 'returns tasks with subtasks' do
      expected = TasksCollection.new([task_with_subtasks])
      expect(subject).to eq(expected)
    end
  end
end
