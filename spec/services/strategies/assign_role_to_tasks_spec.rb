require 'rails_helper'

module Strategies
  describe AssignRoleToTasks do
    let(:strategy) do
      AssignRoleToTasks.new(projects_repository, tasks_repository_factory,
                            tasks_to_role_adder_factory, parallel_iterator)
    end
    let(:projects_repository) do
      ProjectsRepository.new(asana_client, projects_collection)
    end
    let(:asana_client) { instance_double('AsanaClient') }
    let(:projects_collection) do
      ProjectsCollection.new(projects)
    end
    let(:parallel_iterator) { ParallelIterator.new }
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(owner_id: owner_id, tasks: tasks) }
    let(:owner_id) { '7777' }
    let(:tasks) { [TaskObject.new(assignees_ids: [owner_id])] }

    let(:tasks_repository_factory) do
      double(:tasks_repository_factory, new: tasks_repository)
    end
    let(:tasks_repository) do
      instance_double('TaskFilter', assigned_to: assigned_to_owner)
    end
    let(:assigned_to_owner) { [] }

    let(:tasks_to_role_adder_factory) { double(new: tasks_to_role_adder) }
    let(:tasks_to_role_adder) do
      instance_double('TasksToRoleAdder', perform: true)
    end

    describe "#perform" do
      subject { strategy.perform }

      it "assigns project role to the tasks assigned to project owner" do
        expect(projects_collection).to receive(:without_roles)
          .and_return(projects_collection)
        expect(projects_collection).to receive(:with_tasks)
          .and_return(projects_collection)
        expect(tasks_repository).to receive(:assigned_to).with(owner_id)
        expect(tasks_to_role_adder).to receive(:perform)
          .with(project, assigned_to_owner)
        subject
      end
    end
  end
end
