require 'rails_helper'

describe ProjectsRepository do
  let(:repository) { ProjectsRepository.new(asana_client, collection) }
  let(:asana_client) do
    instance_double('AsanaClient',
                    create_project: project,
                    update_project: project,
                    delete_project: true)
  end
  let(:collection) do
    instance_double('ProjectsCollection', add: project, delete: true)
  end
  let(:project) { ProjectObject.new(asana_id: '7777') }

  it_behaves_like "BaseRepository", ProjectsRepository, ProjectsCollection,
    ProjectObject

  describe "#create" do
    subject { repository.create(team_id, attributes) }
    let(:team_id) { '7777' }
    let(:attributes) { {} }

    it "updates Asana" do
      expect(asana_client).to receive(:create_project)
        .with(A9n.asana[:workspace_id], team_id, attributes)
      subject
    end

    it "updates local cache" do
      expect(collection).to receive(:add).with(project)
      subject
    end
  end

  describe "#update" do
    subject { repository.update(project.asana_id, attributes) }
    let(:attributes) { {} }

    it "updates Asana" do
      expect(asana_client).to receive(:update_project)
        .with(project.asana_id, attributes)
      subject
    end

    it "updates local cache" do
      expect(project).to receive(:update).with(attributes)
      subject
    end
  end

  describe "#delete" do
    subject { repository.delete(project.asana_id) }
    let(:attributes) { {} }

    it "updates Asana" do
      expect(asana_client).to receive(:delete_project)
        .with(project.asana_id)
      subject
    end

    it "updates local cache" do
      expect(collection).to receive(:delete).with(project.asana_id)
      subject
    end
  end
end
