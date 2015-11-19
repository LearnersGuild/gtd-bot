require 'rails_helper'

describe TasksFilter do
  let(:tasks_filter) { TasksFilter.new(tasks) }
  let(:tasks) { [assigned_task, unassigned_task, stale_task, forgotten_task] }
  let(:assigned_task) { TaskObject.new(assignee_id: assignee_id) }
  let(:unassigned_task) { TaskObject.new(assignee_id: nil) }
  let(:assignee_id) { '1111' }
  let(:stale_task) do
    TaskObject.new(modified_at: TaskObject::STALE_TIME.ago - 1.minute)
  end
  let(:forgotten_task) do
    TaskObject.new(modified_at: TaskObject::STALE_TIME - 1.minute,
                   tags: [TagObject.new(name: 'stale')])
  end

  describe '#unassigned' do
    subject { tasks_filter.unassigned }

    it 'returns unassigned tasks' do
      expect(subject).to eq([unassigned_task, stale_task, forgotten_task])
    end
  end

  describe '#assigned_to' do
    subject { tasks_filter.assigned_to(assignee_id) }

    it 'returns unassigned tasks' do
      expect(subject).to eq([assigned_task])
    end
  end

  describe '#stale_tasks' do
    subject { tasks_filter.stale_tasks }

    it 'returns unassigned tasks' do
      expect(subject).to eq([stale_task, forgotten_task])
    end
  end

  describe '#forgotten_tasks' do
    subject { tasks_filter.forgotten_tasks }

    it 'returns unassigned tasks' do
      expect(subject).to eq([forgotten_task])
    end
  end
end
