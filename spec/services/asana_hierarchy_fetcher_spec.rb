require 'rails_helper'

describe AsanaHierarchyFetcher do
  let(:fetcher) { AsanaHierarchyFetcher.new(asana_client) }
  let(:asana_client) do
    instance_double('AsanaClient',
                    projects: projects,
                    tasks_for_project: tasks)
  end
  let(:projects) do
    [ProjectObject.new(asana_id: asana_id, name: name, owner_id: owner_id)]
  end
  let(:asana_id) { '7777' }
  let(:name) { 'Project' }
  let(:owner_id) { '8888' }
  let(:tasks) { [TaskObject.new(name: 'Task')] }

  describe "#projects" do
    subject { fetcher.projects }

    it "fetches projects with their details and
    builds hierarchy of our domain objects " do
      project = subject.first
      expect(project.asana_id).to eq(asana_id)
      expect(project.name).to eq(name)
      expect(project.owner_id).to eq(owner_id)
      expect(project.tasks).to eq(tasks)
    end
  end
end
