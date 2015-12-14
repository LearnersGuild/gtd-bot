require 'rails_helper'

describe AsanaHierarchyFetcher do
  let(:fetcher) { AsanaHierarchyFetcher.new(asana_client, parallel_iterator) }
  let(:asana_client) do
    instance_double('AsanaClient',
                    projects: projects,
                    tasks_for_project: tasks,
                    subtasks_for_task: subtasks)
  end
  let(:parallel_iterator) { ParallelIterator.new }
  let(:projects) do
    [ProjectObject.new(asana_id: asana_id, name: name, owner_id: owner_id)]
  end
  let(:projects_with_tasks) {}
  let(:asana_id) { '7777' }
  let(:name) { 'Project' }
  let(:owner_id) { '8888' }
  let(:task) { TaskObject.new(name: 'Task') }
  let(:tasks) { [task] }
  let(:subtasks) { [SubtaskObject.new(name: 'Subtask')] }
  let(:team) { TeamObject.new(asana_id: '1111') }

  describe "#projects" do
    subject { fetcher.projects(team) }

    it "fetches projects with their details and
    builds hierarchy of our domain objects " do
      project = subject.first
      expect(project.asana_id).to eq(asana_id)
      expect(project.name).to eq(name)
      expect(project.owner_id).to eq(owner_id)
      expect(project.tasks).to eq(tasks)
      expect(task.subtasks).to eq(subtasks)
    end
  end
end
