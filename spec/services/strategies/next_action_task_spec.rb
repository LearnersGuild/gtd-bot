require 'rails_helper'

module Strategies
  describe NextActionTask do
    let(:strategy) do
      NextActionTask.new(projects_collection, next_action_task_factory)
    end
    let(:next_action_task_factory) do
      instance_double('NextActionTaskFactory', create: true)
    end
    let(:projects_collection) do
      ProjectsCollection.new(projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new }

    describe '#perform' do
      subject { strategy.perform }

      it 'creates next action task' do
        expect(projects_collection).to receive(:without_roles)
          .and_return(projects_collection)
        expect(projects_collection).to receive(:without_tasks)
          .and_return(projects_collection)
        expect(next_action_task_factory).to receive(:create).with(project)
        subject
      end
    end
  end
end
