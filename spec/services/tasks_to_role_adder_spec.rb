require 'rails_helper'

describe TasksToRoleAdder do
  let(:creator) { TasksToRoleAdder.new(description_parser, asana_client) }
  let(:description_parser) do
    instance_double('DescriptionParser', roles: [role_id])
  end
  let(:role_id) { '7777' }
  let(:asana_client) do
    instance_double('AsanaClient', add_project_to_task: true)
  end

  describe "#perform" do
    subject { creator.perform(project, tasks) }

    let(:project) { ProjectObject.new(description: "role") }
    let(:tasks) { [task] }
    let(:task) { TaskObject.new(asana_id: '7777') }

    it "assigns tasks to project role" do
      expect(description_parser).to receive(:roles)
        .with(project.description)
      expect(asana_client).to receive(:add_project_to_task)
        .with(task.asana_id, role_id)
      subject
    end
  end
end
