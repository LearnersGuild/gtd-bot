require 'rails_helper'

describe TasksAssigner do
  let(:tasks_assigner) do
    TasksAssigner.new(tasks_repository, parallel_iterator)
  end
  let(:tasks_repository) { double('TasksRepository') }
  let(:parallel_iterator) { ParallelIterator.new }
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
