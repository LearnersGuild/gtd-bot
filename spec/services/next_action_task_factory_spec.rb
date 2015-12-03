require 'rails_helper'

describe NextActionTaskFactory do
  let(:factory) { NextActionTaskFactory.new }

  describe "#create" do
    subject { factory.create(tasks_repository, project) }
    let(:tasks_repository) { double('TasksRepository') }

    let(:project) do
      ProjectObject.new(asana_id: '7777', owner_id: '8888', name: 'Project')
    end

    it "creates task in Asana" do
      expected_name =
        "#{NextActionTaskFactory::TITLE} #{project.name}"
      expect(tasks_repository).to receive(:create)
        .with(project, name: expected_name, assignee: project.owner_id,
                       notes: project.link)
      subject
    end
  end
end
