require 'rails_helper'

module Strategies
  describe CommentForgottenTasks do
    let(:strategy) do
      CommentForgottenTasks.new(projects_filter, tasks_filter_factory,
                            asana_client)
    end
    let(:projects_filter) do
      instance_double('ProjectsFilter', with_tasks: projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(tasks: tasks) }
    let(:tasks) { [TaskObject.new, forgotten_task] }
    let(:forgotten_task) do
      TaskObject.new(tag: tags, modified_at: TaskObject::STALE_TIME - 1.minute)
    end
    let(:tags) { [TagObject.new(name: 'stale')] }
    let(:tasks_filter_factory) do
      double(:tasks_filter_factory, new: tasks_filter)
    end
    let(:tasks_filter) do
      instance_double('TasksFilter',
                      forgotten_tasks: forgotten_tasks)
    end
    let(:forgotten_tasks) { [forgotten_task] }
    let(:asana_client) do
      instance_double('AsanaClient', add_comment_to_task: true)
    end
    let(:comment) { Strategies::CommentForgottenTasks::COMMENT }

    describe '#perform' do
      subject { strategy.perform }

      it 'comments stale tasks' do
        expect(tasks_filter_factory).to receive(:new).with(tasks)
        expect(tasks_filter).to receive(:forgotten_tasks)
        expect(asana_client).to receive(:add_comment_to_task)
          .with(forgotten_task.asana_id, comment)
        subject
      end
    end
  end
end
