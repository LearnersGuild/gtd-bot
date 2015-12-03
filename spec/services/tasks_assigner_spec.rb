require 'rails_helper'

describe TasksAssigner do
  let(:tasks_assigner) { TasksAssigner.new(tasks_repository) }
  let(:tasks_repository) { double('TasksRepository') }
  let(:assignee_id) { double }
  let(:tasks) { [task] }
  let(:task) { TaskObject.new(id: double) }

  describe '#perform' do
    subject { tasks_assigner.perform(tasks, assignee_id) }

    it 'assigns task' do
      expect(tasks_repository).to receive(:update)
        .with(task, assignee: assignee_id)
      subject
    end
  end
end
