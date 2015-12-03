require 'rails_helper'

describe TasksRepository do
  let(:repository) { TasksRepository.new(asana_client, collection) }
  let(:asana_client) do
    instance_double('AsanaClient',
                    create_task: task,
                    update_task: task,
                    add_comment_to_task: true,
                    add_project_to_task: true)
  end
  let(:collection) do
    instance_double('TasksCollection', add: task, delete: true)
  end
  let(:task) { TaskObject.new(asana_id: '7777') }
  let(:project) { ProjectObject.new(asana_id: '8888') }

  describe "#create" do
    subject { repository.create(project, attributes) }
    let(:attributes) { {} }

    it "updates Asana" do
      expect(asana_client).to receive(:create_task)
        .with(A9n.asana[:workspace_id], project.asana_id, attributes)
      subject
    end

    it "updates local cache" do
      subject
      expect(project.tasks.first).to eq(task)
    end
  end

  describe "#update" do
    subject { repository.update(task, attributes) }
    let(:attributes) { {} }

    it "updates Asana" do
      expect(asana_client).to receive(:update_task)
        .with(task.asana_id, task.attributes)
      subject
    end

    it "updates local cache" do
      expect(task).to receive(:update).with(task.attributes)
      subject
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
end
