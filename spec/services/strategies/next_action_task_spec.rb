require 'rails_helper'

module Strategies
  describe NextActionTask do
    let(:strategy) do
      NextActionTask.new(projects_repository, next_action_task_factory,
                        tasks_repository_factory)
    end
    let(:next_action_task_factory) do
      instance_double('NextActionTaskFactory', create: true)
    end
    let(:projects_repository) do
      ProjectsRepository.new(double(:asana_client), projects_collection)
    end
    let(:projects_collection) do
      ProjectsCollection.new(projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new }

    let(:tasks_repository_factory) { double(new: tasks_repository) }
    let(:tasks_repository) { double(:tasks_repository) }

    describe '#perform' do
      subject { strategy.perform }

      it 'creates next action task' do
        expect(projects_collection).to receive(:without_roles)
          .and_return(projects_collection)
        expect(projects_collection).to receive(:without_tasks)
          .and_return(projects_collection)
        expect(next_action_task_factory).to receive(:create)
          .with(tasks_repository, project)
        subject
      end
    end
  end
end
