require 'rails_helper'

module Strategies
  describe NextActionTask do
    let(:strategy) do
      NextActionTask.new(projects_filter, next_action_task_factory)
    end
    let(:next_action_task_factory) do
      instance_double('NextActionTaskFactory', create: true)
    end
    let(:projects_filter) do
      instance_double('ProjectsFilter', without_roles_and_tasks: projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new }

    describe '#perform' do
      subject { strategy.perform }

      it 'creates next action task' do
        expect(projects_filter).to receive(:without_roles_and_tasks)
        expect(next_action_task_factory).to receive(:create).with(project)
        subject
      end
    end
  end
end
