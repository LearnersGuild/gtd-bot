require 'rails_helper'

describe NextActionTaskFactory do
  let(:factory) { NextActionTaskFactory.new(asana_client) }
  let(:asana_client) { instance_double('AsanaClient') }

  describe "#create" do
    subject { factory.create(project) }

    let(:project) do
      ProjectObject.new(asana_id: '7777', owner_id: '8888', name: 'Project')
    end

    it "creates task in Asana" do
      expected_name =
        "#{NextActionTaskFactory::TITLE} @#{project.name}"
      expect(asana_client).to receive(:create_task)
        .with(A9n.asana[:workspace_id], project.asana_id,
              name: expected_name, assignee: project.owner_id)
      subject
    end
  end
end
