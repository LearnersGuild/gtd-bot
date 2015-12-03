require 'rails_helper'

module Strategies
  describe AssignRoleTask do
    let(:strategy) do
      AssignRoleTask.new(projects_collection, assign_role_task_factory,
                         parallel_iterator)
    end
    let(:projects_collection) do
      instance_double('ProjectsCollection', without_roles_assigned: projects)
    end
    let(:assign_role_task_factory) do
      instance_double('AssignRoleTaskFactory')
    end
    let(:parallel_iterator) { ParallelIterator.new }
    let(:projects) { [project] }
    let(:project) { ProjectObject.new }

    describe "#perform" do
      subject { strategy.perform }

      it "creates role task" do
        expect(projects_collection).to receive(:without_roles_assigned)
        expect(assign_role_task_factory).to receive(:create).with(project)
        subject
      end
    end
  end
end
