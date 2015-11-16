require 'rails_helper'

describe AssignRoleTaskFactory do
  let(:factory) { AssignRoleTaskFactory.new(asana_client) }
  let(:asana_client) do
    instance_double('AsanaClient', create_task: true)
  end

  describe "#create" do
    subject { factory.create(project) }
    let(:project) { ProjectObject.new }

    it "delegates to Asana" do
      expected_name =
        "#{AssignRoleTaskFactory::TITLE} @#{project.name}"
      expect(asana_client).to receive(:create_task).with(
        A9n.asana[:workspace_id], project.asana_id,
        name: expected_name,
        assignee: project.owner_id,
        notes: AssignRoleTaskFactory::DESCRIPTION
      )
      subject
    end
  end
end
