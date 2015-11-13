require 'rails_helper'

module Strategies
  describe AssignRoleToTasks do
    let(:strategy) do
      AssignRoleToTasks.new(project_filter, task_filter_factory,
                            tasks_role_creator)
    end
    let(:project_filter) do
      instance_double('ProjectFilter', with_tasks: projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(owner_id: owner_id, tasks: tasks) }
    let(:owner_id) { '7777' }
    let(:tasks) { [TaskObject.new(assignees_ids: [owner_id])] }

    let(:task_filter_factory) do
      double(:task_filter_factory, new: task_filter)
    end
    let(:task_filter) do
      double('TaskFilter', assigned_to_owner: assigned_to_owner)
    end
    let(:assigned_to_owner) { [] }

    let(:tasks_role_creator) { double('TasksRoleCreator', perform: true) }

    describe "#perform" do
      subject { strategy.perform }

      it "assigns project role to the tasks assigned to project owner" do
        expect(project_filter).to receive(:with_tasks)
        expect(task_filter).to receive(:assigned_to_owner).with(owner_id)
        expect(tasks_role_creator).to receive(:perform)
          .with(project, assigned_to_owner)
        subject
      end
    end
  end
end
