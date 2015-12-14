require 'rails_helper'

module Strategies
  describe StaleTask do
    let(:strategy) do
      StaleTask.new(projects_repository, tasks_repository_factory,
                    task_tagger_factory, tags_repository, parallel_iterator,
                    strategies_repository)
    end
    let(:projects_repository) do
      double('ProjectsRepository', with_tasks: projects)
    end
    let(:strategies_repository) do
      instance_double('StrategiesRepository',
                      register_performing: true,
                      already_performed?: false)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(tasks: tasks) }
    let(:tasks_repository_factory) do
      double(:tasks_repository_factory, new: tasks_repository)
    end
    let(:tasks_repository) do
      double('TasksRepository', stale_tasks: stale_tasks)
    end
    let(:parallel_iterator) { ParallelIterator.new }
    let(:tasks) { [TaskObject.new, stale_task] }
    let(:stale_task) { TaskObject.new }
    let(:stale_tasks) { [stale_task] }
    let(:task_tagger_factory) { double(new: task_tagger) }
    let(:task_tagger) { instance_double('TaskTagger') }
    let(:tags_repository) { instance_double('TagsRepository') }
    let(:parallel_iterator) { instance_double('ParallelIterator') }

    describe '#perform' do
      subject { strategy.perform }
      it 'tags stale tasks' do
        expect(task_tagger_factory).to receive(:new)
          .with(tags_repository, parallel_iterator, strategies_repository)
        expect(task_tagger).to receive(:perform).with(stale_tasks, 'stale')
        subject
      end
    end
  end
end

