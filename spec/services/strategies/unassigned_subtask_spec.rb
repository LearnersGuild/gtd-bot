require 'rails_helper'

module Strategies
  describe UnassignedSubtask do
    let(:strategy) do
      UnassignedSubtask.new(projects_repository, tasks_repository_factory,
                            subtasks_repository_factory, assigner_factory,
                            subtasks_owner_setter_factory, parallel_iterator)
    end
    let(:asana_client) { instance_double('AsanaClient') }
    let(:projects_repository) do
      ProjectsRepository.new(asana_client, projects_collection)
    end
    let(:tasks_repository_factory) do
      double(:tasks_repository_factory, new: tasks_repository)
    end
    let(:tasks_repository) do
      instance_double('TasksRepository')
    end
    let(:projects_collection) { ProjectsCollection.new(projects) }
    let(:projects) { [ProjectObject.new(tasks: tasks)] }
    let(:tasks) { [TaskObject.new] }
    let(:assigner_factory) { double(:assigner_factory) }
    let(:subtasks_repository_factory) { double(:subtasks_repository_factory) }
    let(:subtasks_owner_setter_factory) do
      double(:subtasks_owner_setter_factory, new: subtasks_owner_setter)
    end
    let(:subtasks_owner_setter) { instance_double('SubtasksOwnerSetter') }
    let(:parallel_iterator) { ParallelIterator.new }

    describe '#perform' do
      subject { strategy.perform }

      it 'assigns subtasks' do
        expect(projects_collection).to receive(:with_tasks)
          .and_return(projects_collection)
        expect(tasks_repository_factory).to receive(:new).with(tasks)
        expect(subtasks_owner_setter_factory).to receive(:new)
          .with(subtasks_repository_factory, assigner_factory,
                parallel_iterator)
        expect(subtasks_owner_setter).to receive(:perform)
          .with(tasks_repository)

        subject
      end
    end
  end
end
