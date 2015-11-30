require 'rails_helper'

module Strategies
  describe AssignRoleToTasks do
    let(:strategy) do
      AssignRoleToTasks.new(projects_filter, task_filter_factory,
                            tasks_to_role_adder)
    end
    let(:projects_filter) do
      instance_double('ProjectFilter', without_roles_with_tasks: projects)
    end
    let(:asana_client) { instance_double('AsanaClient') }
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(owner_id: owner_id, tasks: tasks) }
    let(:owner_id) { '7777' }
    let(:tasks) { [TaskObject.new(assignees_ids: [owner_id])] }

    let(:task_filter_factory) do
      double(:task_filter_factory, new: task_filter)
    end
    let(:task_filter) do
      instance_double('TaskFilter', assigned_to: assigned_to_owner)
    end
    let(:assigned_to_owner) { [] }

    let(:tasks_to_role_adder) do
      instance_double('TasksToRoleAdder', perform: true)
    end

    describe "#perform" do
      subject { strategy.perform }

      it "assigns project role to the tasks assigned to project owner" do
        expect(projects_filter).to receive(:without_roles_with_tasks)
        expect(task_filter).to receive(:assigned_to).with(owner_id)
        expect(tasks_to_role_adder).to receive(:perform)
          .with(project, assigned_to_owner)
        subject
      end
    end
  end
end
