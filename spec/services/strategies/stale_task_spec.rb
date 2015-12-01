require 'rails_helper'

module Strategies
  describe StaleTask do
    let(:strategy) do
      StaleTask.new(projects_collection, tasks_filter_factory, task_tagger)
    end
    let(:projects_collection) do
      instance_double('ProjectsCollection', with_tasks: projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(tasks: tasks) }
    let(:tasks_filter_factory) do
      double(:tasks_filter_factory, new: tasks_filter)
    end
    let(:tasks_filter) do
      instance_double('TasksFilter', stale_tasks: stale_tasks)
    end
    let(:tasks) { [TaskObject.new, stale_task] }
    let(:stale_task) { TaskObject.new }
    let(:stale_tasks) { [stale_task] }
    let(:task_tagger) { instance_double('TaskTagger') }

    describe '#perform' do
      subject { strategy.perform }
      it 'tags stale tasks' do
        expect(task_tagger).to receive(:perform).with(stale_tasks, 'stale')
        subject
      end
    end
  end
end

