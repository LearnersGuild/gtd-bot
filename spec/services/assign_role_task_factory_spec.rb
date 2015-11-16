require 'rails_helper'

describe AssignRoleTaskFactory do
  let(:factory) { AssignRoleTaskFactory.new(asana_client) }
  let(:asana_client) do
    instance_double('AsanaClient', create_task: true)
  end

  describe "#create" do
    subject { factory.create(project) }
    let(:project) { ProjectObject.new(name: 'Project', tasks: tasks) }
    let(:tasks) { [] }
    let(:expected_name) { "#{AssignRoleTaskFactory::TITLE} @Project" }

    it "delegates to Asana" do
      expect(asana_client).to receive(:create_task).with(
        A9n.asana[:workspace_id], project.asana_id,
        name: expected_name,
        assignee: project.owner_id,
        notes: AssignRoleTaskFactory::DESCRIPTION
      )
      subject
    end

    context "tasks already created" do
      let(:tasks) { [TaskObject.new(name: expected_name)] }

      it "does not dupplicate task" do
        expect(asana_client).not_to receive(:create_task)
        subject
      end
    end
  end
end
