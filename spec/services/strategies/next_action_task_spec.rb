require 'rails_helper'

module Strategies
  describe NextActionTask do
    subject { NextActionTask.new(projects_filter, next_action_task_factory) }
    let(:next_action_task_factory) do
      instance_double('NextActionTaskFactory', create: true)
    end
    let(:projects_filter) do
      instance_double('ProjectsFilter', without_tasks: projects)
    end
    let(:projects) { [project] }
    let(:project) { ProjectObject.new }

    describe '#perform' do
      it 'creates next action task' do
        expect(projects_filter).to receive(:without_tasks)
        expect(next_action_task_factory).to receive(:create).with(project)
        subject.perform
      end
    end
  end
end
