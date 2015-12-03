require 'rails_helper'

describe TasksToRoleAdder do
  let(:adder) do
    TasksToRoleAdder.new(tasks_repository)
  end
  let(:roles_repository) do
    instance_double('RolesRepository', all: [role])
  end
  let(:role_id) { '7777' }
  let(:role) { ProjectObject.new(id: role_id) }
  let(:tasks_repository) do
    double('TasksRepository', add_project_to_task: true)
  end

  describe "#perform" do
    subject { adder.perform(project, tasks) }

    let(:project) { ProjectObject.new(description: "role") }
    let(:tasks) { [task] }
    let(:task) { TaskObject.new(asana_id: '7777') }

    before do
      expect(adder).to receive(:roles_repository).and_return(roles_repository)
    end

    it "assigns tasks to project role" do
      expect(project).to receive(:linked_role_ids)
        .with([role]).and_return([role_id])
      expect(tasks_repository).to receive(:add_project_to_task)
        .with(task, role_id)
      subject
    end
  end
end
