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
  let(:project) { ProjectObject.new(asana_id: '7777', name: name) }
  let(:name) { 'Name' }

  it_behaves_like "BaseRepository", ProjectsRepository, ProjectsCollection,
    ProjectObject

  describe "#create" do
    subject { repository.create(team_id, attributes) }
    let(:team_id) { '7777' }
    let(:attributes) { {} }

    it "updates Asana" do
      expect(asana_client).to receive(:create_project)
        .with(ENV.fetch('ASANA_WORKSPACE_ID'), team_id, attributes)
      subject
    end

    it "updates local cache" do
      expect(collection).to receive(:add).with(project)
      subject
    end

    context "AsanaClient returns with nil" do
      before do
        expect(asana_client).to receive(:create_project).and_return(nil)
      end

      it "does not update local cache" do
        expect(collection).not_to receive(:add).with(project)
        subject
      end
    end
  end

  describe "#update" do
    subject { repository.update(project, attributes) }
    let(:attributes) { { name: updated_name } }
    let(:updated_name) { 'New name' }
    let(:updated_project) { ProjectObject.new(attributes) }

    it "updates Asana" do
      expect(asana_client).to receive(:update_project)
        .with(project.asana_id, attributes)
      subject
    end

    it "updates local cache" do
      expect(asana_client).to receive(:update_project)
        .with(project.asana_id, attributes)
        .and_return(updated_project)
      subject
      expect(project.name).to eq(updated_name)
    end

    context "AsanaClient returns with nil" do
      before do
        expect(asana_client).to receive(:update_project).and_return(nil)
      end

      it "does not update local cache" do
        subject
        expect(project.name).to eq(name)
      end
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

    context "AsanaClient returns with nil" do
      before do
        expect(asana_client).to receive(:delete_project).and_return(nil)
      end

      it "does not update local cache" do
        subject
        expect(collection).not_to receive(:delete).with(project.asana_id)
      end
    end
  end
end
