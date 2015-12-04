require 'rails_helper'

describe AssignRoleTaskFactory do
  let(:factory) { AssignRoleTaskFactory.new(tasks_repository) }
  let(:tasks_repository) do
    double('TasksRepository', create: TaskObject.new)
  end

  describe "#create" do
    subject { factory.create(project) }
    let(:project) { ProjectObject.new(name: 'Project', tasks: tasks) }
    let(:tasks) { [] }
    let(:expected_name) { "#{AssignRoleTaskFactory::TITLE} Project" }

    it "delegates to Asana" do
      expect(tasks_repository).to receive(:create).with(
        project,
        name: expected_name,
        assignee: project.owner_id,
        notes: AssignRoleTaskFactory::DESCRIPTION % project.link
      )
      subject
    end

    context "tasks already created" do
      let(:tasks) { [TaskObject.new(name: expected_name)] }

      it "does not dupplicate task" do
        expect(tasks_repository).not_to receive(:create)
        subject
      end
    end
  end
end
