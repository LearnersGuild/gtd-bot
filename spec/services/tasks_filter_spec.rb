require 'rails_helper'

describe TasksFilter do
  let(:tasks_filter) { TasksFilter.new(tasks) }
  let(:tasks) { [assigned_task, unassigned_task] }
  let(:assigned_task) { TaskObject.new(assignee_id: assignee_id) }
  let(:unassigned_task) { TaskObject.new(assignee_id: nil) }
  let(:assignee_id) { 1111 }

  describe '#unassigned' do
    subject { tasks_filter.unassigned }

    it 'returns unassigned tasks' do
      expect(subject).to eq([unassigned_task])
    end
  end
end
