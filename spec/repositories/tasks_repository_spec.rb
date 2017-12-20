require 'rails_helper'

describe TasksRepository do
  let(:repository) { TasksRepository.new(asana_client, collection) }
  let(:asana_client) do
    instance_double('AsanaClient',
                    create_task: task,
                    update_task: task,
                    add_comment_to_task: true,
                    add_project_to_task: true,
                    delete_task: true)
  end
  let(:collection) do
    TasksCollection.new([task])
  end
  let(:task) { TaskObject.new(asana_id: task_id) }
  let(:task_id) { '7777' }
  let(:project) { ProjectObject.new(asana_id: '8888') }

  it_behaves_like "BaseRepository", TasksRepository, TasksCollection, TaskObject

  describe "#create" do
    subject { repository.create(project, attributes) }
    let(:attributes) { {} }

    it "updates Asana" do
      expect(asana_client).to receive(:create_task)
        .with(ENV.fetch('ASANA_WORKSPACE_ID'), project.asana_id, attributes)
      subject
    end

    it "updates local cache" do
      subject
      expect(project.tasks.first).to eq(task)
    end

    context "AsanaClient returns with nil" do
      before do
        expect(asana_client).to receive(:create_task).and_return(nil)
      end

      it "deosn't update project" do
        subject
        expect(project.tasks).not_to include(task)
      end
    end
  end

  describe "#update" do
    subject { repository.update(task, attributes) }
    let(:attributes) { { name: updated_name } }
    let(:updated_name) { 'New name' }
    let(:updated_modified_at) { DateTime.parse("10.07.1987") }
    let(:updated_task) do
      TaskObject.new(attributes.merge(modified_at: updated_modified_at))
    end

    it "updates Asana" do
      expect(asana_client).to receive(:update_task)
        .with(task.asana_id, attributes)
      subject
    end

    it "updates local cache" do
      expect(asana_client).to receive(:update_task)
        .with(task.asana_id, attributes)
        .and_return(updated_task)
      subject
      expect(task.name).to eq(updated_name)
      expect(task.modified_at).to eq(updated_modified_at)
    end

    context "AsanaClient returns with nil" do
      before do
        expect(asana_client).to receive(:update_task).and_return(nil)
      end

      it "deosn't update task" do
        expect(task).not_to receive(:update)

        subject
      end
    end
  end

  describe "#add_comment_to_task" do
    subject { repository.add_comment_to_task(task, 'comment') }

    it "updates Asana" do
      expect(asana_client).to receive(:add_comment_to_task)
        .with(task.asana_id, 'comment')
      subject
    end
  end

  describe "#add_project_to_task" do
    subject { repository.add_project_to_task(task, project_id) }

    let(:project_id) { '8888' }

    it "updates Asana" do
      expect(asana_client).to receive(:add_project_to_task)
        .with(task.asana_id, project_id)
      subject
    end

    it "updates local cache" do
      subject
      expect(task.project_ids).to eq([project_id])
    end

    context "project already assigned to a task" do
      let(:task) do
        TaskObject.new(asana_id: task_id, project_ids: [project_id])
      end

      it "does not update Asana" do
        expect(asana_client).not_to receive(:add_project_to_task)
          .with(task.asana_id, project_id)
        subject
      end

      it "does not update local cache" do
        subject
        expect(task.project_ids).to eq([project_id])
      end
    end

    context "AsanaClient returns with nil" do
      before do
        expect(asana_client).to receive(:add_project_to_task).and_return(nil)
      end

      it "does not update local cache" do
        subject
        expect(task.project_ids).to eq([])
      end
    end
  end

  describe "#delete" do
    subject { repository.delete(task_id) }

    it "updates Asana" do
      expect(asana_client).to receive(:delete_task).with(task_id)
      subject
    end

    it "updates local cache" do
      subject
      expect(collection).to be_empty
    end

    context "AsanaClient returns with nil" do
      before do
        expect(asana_client).to receive(:delete_task).and_return(nil)
      end

      it "does not update local cache" do
        subject
        expect(collection.items).to eq([task])
      end
    end
  end
end
