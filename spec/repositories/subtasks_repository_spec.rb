require 'rails_helper'

describe SubtasksRepository do
  let(:repository) { SubtasksRepository.new(asana_client, collection) }
  let(:asana_client) do
    instance_double('AsanaClient', update_task: subtask)
  end
  let(:collection) do
    SubtasksCollection.new([subtask])
  end
  let(:subtask) { SubtaskObject.new(asana_id: subtask_id) }
  let(:subtask_id) { '7777' }

  it_behaves_like "BaseRepository", SubtasksRepository, SubtasksCollection,
    SubtaskObject

  describe "#update" do
    subject { repository.update(subtask, attributes) }
    let(:attributes) { { name: updated_name } }
    let(:updated_name) { 'New name' }
    let(:updated_subtask) do
      SubtaskObject.new(attributes)
    end

    it "updates Asana" do
      expect(asana_client).to receive(:update_subtask)
        .with(subtask.asana_id, attributes)
      subject
    end

    it "updates local cache" do
      expect(asana_client).to receive(:update_subtask)
        .with(subtask.asana_id, attributes)
        .and_return(updated_subtask)
      subject
      expect(subtask.name).to eq(updated_name)
    end

    context "AsanaClient returns with nil" do
      before do
        expect(asana_client).to receive(:update_subtask).and_return(nil)
      end

      it "deosn't update subtask" do
        expect(subtask).not_to receive(:update)

        subject
      end
    end
  end
end
