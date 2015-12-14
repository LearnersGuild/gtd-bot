require 'rails_helper'

module Strategies
  describe UnassignedTask do
    let(:strategy) do
      UnassignedTask.new(projects_repository, tasks_repository_factory,
                         assigner_factory, parallel_iterator)
    end
    let(:projects_repository) do
      ProjectsRepository.new(asana_client, projects_collection)
    end
    let(:asana_client) { instance_double('AsanaClient') }
    let(:projects_collection) { ProjectsCollection.new(projects) }
    let(:tasks_repository) do
      TasksRepository.new(asana_client, tasks_collection)
    end
    let(:tasks_collection) { TasksCollection.new(tasks) }
    let(:tasks_repository_factory) do
      instance_double('TasksRepositoryFactory', new: tasks_repository)
    end
    let(:assigner_factory) { double(:assigner_factory, new: tasks_assigner) }
    let(:tasks_assigner) { instance_double('Assigner', perform: true) }
    let(:parallel_iterator) { ParallelIterator.new }
    let(:tasks) { [task] }
    let(:task) { TaskObject.new }
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(tasks: tasks, owner_id: "77777") }
    let(:unassigned_tasks) { [unassigned_task] }
    let(:unassigned_task) { TaskObject.new(asignee: [double]) }

    describe '#perform' do
      subject { strategy.perform }

      it 'assigns unnasigned task to project owner' do
        expect(projects_collection).to receive(:without_roles)
          .and_return(projects_collection)
        expect(projects_collection).to receive(:with_tasks)
          .and_return(projects_collection)
        expect(tasks_repository_factory).to receive(:new).with(tasks)
        expect(tasks_collection).to receive(:unassigned)
          .and_return(tasks_collection)
        expect(assigner_factory).to receive(:new)
          .with(tasks_repository)
        expect(tasks_assigner).to receive(:perform)
          .with(tasks_collection, project.owner_id)

        subject
      end
    end
  end
end
