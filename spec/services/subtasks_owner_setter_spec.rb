require 'rails_helper'

describe SubtasksOwnerSetter do
  let(:subtasks_owner_setter) do
    SubtasksOwnerSetter.new(subtasks_repository_factory, assigner_factory,
                            parallel_iterator)
  end
  let(:subtasks_repository_factory) do
    double(:subtasks_repository_factory, new: subtasks_repository)
  end
  let(:assigner_factory) { double(:assigner_factory, new: subtasks_assigner) }
  let(:subtasks_assigner) { instance_double('Assigner', perform: true) }
  let(:parallel_iterator) { ParallelIterator.new }
  let(:subtasks_repository) do
    SubtasksRepository.new(asana_client, subtasks_collection)
  end
  let(:subtasks_collection) { SubtasksCollection.new(subtasks) }
  let(:tasks_repository) do
    TasksRepository.new(asana_client, tasks_collection)
  end
  let(:asana_client) { instance_double('AsanaClient') }
  let(:tasks_collection) { TasksCollection.new(tasks) }
  let(:tasks) { [task] }
  let(:task) { TaskObject.new(assignee_id: assignee_id, subtasks: subtasks) }
  let(:assignee_id) { '111' }
  let(:subtasks) { [SubtaskObject.new(assignee_id: '111'), unassigned_subtask] }
  let(:unassigned_subtask) { SubtaskObject.new }
  let(:unassigned_subtasks) { [unassigned_subtask] }

  describe '#perform' do
    subject { subtasks_owner_setter.perform(tasks_repository) }

    it 'assigns subtasks to task owner' do
      expect(tasks_collection).to receive(:with_subtasks)
        .and_return(tasks)
      expect(subtasks_repository_factory).to receive(:new)
        .with(task.subtasks)
      expect(assigner_factory).to receive(:new)
        .with(subtasks_repository, parallel_iterator)
      expect(subtasks_collection).to receive(:unassigned)
        .and_return(unassigned_subtasks)
      expect(subtasks_assigner).to receive(:perform)
        .with(unassigned_subtasks, assignee_id)

      subject
    end
  end
end
