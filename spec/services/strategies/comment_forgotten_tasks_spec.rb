require 'rails_helper'

module Strategies
  describe CommentForgottenTasks do
    let(:strategy) do
      CommentForgottenTasks.new(projects_repository, tasks_repository_factory,
                                strategies_repository, parallel_iterator)
    end
    let(:projects_repository) do
      double('ProjectsRepository', with_tasks: projects)
    end
    let(:strategies_repository) do
      instance_double('StrategiesRepository',
                      register_performing: true,
                      already_performed?: false)
    end
    let(:parallel_iterator) { ParallelIterator.new }
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

      context "strategy already performed" do
        it 'does not add tag to tasks' do
          expect(strategies_repository).to receive(:already_performed?)
            .and_return(true)
          expect(tasks_repository).not_to receive(:add_comment_to_task)
            .with(forgotten_task, comment)
          subject
        end
      end
    end
  end
end
