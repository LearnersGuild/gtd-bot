require 'rails_helper'

module Strategies
  describe EveryoneTask do
    let(:strategy) do
      EveryoneTask.new(projects_repository, tasks_repository_factory, team,
                       personal_task_duplicator_factory)
    end
    let(:team) { TeamObject.new }
    let(:projects_repository) do
      double('ProjectsRepository', everyone: projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new(name: "&Everyone", tasks: tasks) }
    let(:tasks) { [TaskObject.new] }
    let(:tasks_repository_factory) do
      instance_double("TasksRepositoryFactory", new: tasks_repository)
    end
    let(:tasks_repository) { instance_double("TasksRepository") }
    let(:personal_task_duplicator_factory) do
      double(:personal_task_duplicator_factory, new: personal_task_duplicator)
    end
    let(:personal_task_duplicator) do
      instance_double("PersonalTaskDuplicator", perform: true)
    end

    describe '#perform' do
      subject { strategy.perform }

      it 'duplicates tasks' do
        expect(tasks_repository_factory).to receive(:new).with(tasks)
        expect(personal_task_duplicator_factory).to receive(:new)
          .with(tasks_repository, team, project)
        expect(personal_task_duplicator).to receive(:perform)

        subject
      end
    end
  end
end
