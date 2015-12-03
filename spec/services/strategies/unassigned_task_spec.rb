require 'rails_helper'

module Strategies
  describe UnassignedTask do
    let(:strategy) do
      UnassignedTask.new(projects_repository, tasks_filter_factory,
                         tasks_assigner)
    end
    let(:projects_repository) do
      ProjectsRepository.new(asana_client, projects_collection)
    end
    let(:asana_client) { instance_double('AsanaClient') }
    let(:projects_collection) do
      ProjectsCollection.new(projects)
    end
    let(:tasks_filter_factory) do
      double(:tasks_filter_factory, new: tasks_filter)
    end
    let(:tasks_filter) do
      instance_double('TasksFilter', unassigned: unassigned_tasks)
    end
    let(:tasks_assigner) { instance_double('TasksAssigner', perform: true) }
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
        expect(tasks_filter_factory).to receive(:new).with(tasks)
        expect(tasks_filter).to receive(:unassigned)
        expect(tasks_assigner).to receive(:perform).with(unassigned_tasks,
                                                         project.owner_id)
        subject
      end
    end
  end
end
