require 'rails_helper'

module Strategies
  describe UnassignedTask do
    subject do
      UnassignedTask.new(projects_filter, tasks_filter_factory, tasks_assigner)
    end
    let(:projects_filter) do
      instance_double('ProjectsFilter', with_tasks: projects)
    end
    let(:tasks_filter_factory) do
      double(:tasks_filter_factory, new: tasks_filter)
    end
    let(:tasks_filter) do
      instance_double('TasksFilter', unassigned: tasks)
    end
    let(:tasks_assigner) { instance_double('TasksAssigner', perform: true) }
    let(:tasks) { [task] }
    let(:task) { double }
    let(:projects) { [project] }
    let(:project) { double(tasks: tasks, owner: double) }

    describe '#perform' do
      it 'assigns unnasigned task to project owner' do
        expect(projects_filter).to receive(:with_tasks)
        subject.perform
      end
    end
  end
end
