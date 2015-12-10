require 'rails_helper'

module Strategies
  describe CommentForgottenTasks do
    let(:strategy) do
      CommentForgottenTasks.new(projects_repository, tasks_repository_factory)
    end
    let(:projects_repository) do
      double('ProjectsRepository', with_tasks: projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(tasks: tasks) }
    let(:tasks) { [TaskObject.new, forgotten_task] }
    let(:forgotten_task) { TaskObject.new }
    let(:tags) { [TagObject.new(name: 'stale')] }
    let(:tasks_repository_factory) do
      double(:tasks_repository_factory, new: tasks_repository)
    end
    let(:tasks_repository) do
      instance_double('TasksFilter',
                      forgotten_tasks: forgotten_tasks)
    end
    let(:forgotten_tasks) { [forgotten_task] }
    let(:comment) { Strategies::CommentForgottenTasks::COMMENT }

    describe '#perform' do
      subject { strategy.perform }

      it 'comments stale tasks' do
        expect(tasks_repository_factory).to receive(:new).with(tasks)
        expect(tasks_repository).to receive(:forgotten_tasks)
        expect(tasks_repository).to receive(:add_comment_to_task)
          .with(forgotten_task, comment)
        subject
      end
    end
  end
end
