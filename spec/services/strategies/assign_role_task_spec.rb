require 'rails_helper'

module Strategies
  describe AssignRoleTask do
    let(:strategy) do
      AssignRoleTask.new(projects_filter, assign_role_task_factory)
    end
    let(:projects_filter) do
      instance_double('ProjectsFilter', without_roles: projects)
    end
    let(:assign_role_task_factory) do
      instance_double('AssignRoleTaskFactory')
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new }

    describe "#perform" do
      subject { strategy.perform }

      it "creates role task" do
        expect(projects_filter).to receive(:without_roles)
        expect(assign_role_task_factory).to receive(:create).with(project)
        subject
      end
    end
  end
end
