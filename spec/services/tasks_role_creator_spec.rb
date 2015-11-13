require 'rails_helper'

describe TasksRoleCreator do
  let(:creator) { TasksRoleCreator.new(task_description_builder, asana_client) }
  let(:task_description_builder) do
    instance_double('TaskDescriptionBuilder',
                    with_project_roles: new_description)
  end
  let(:asana_client) do
    instance_double('AsanaClient', update_task: true)
  end
  let(:new_description) { '@Tester Very important task' }

  describe "#perform" do
    subject { creator.perform(project, tasks) }

    let(:project) { ProjectObject.new }
    let(:tasks) { [task] }
    let(:task) { TaskObject.new(asana_id: '7777') }

    it "assigns tasks to project role" do
      expect(task_description_builder).to receive(:with_project_roles)
        .with(task, project)
      expect(asana_client).to receive(:update_task)
        .with(task.asana_id, notes: new_description)
      subject
    end
  end
end
