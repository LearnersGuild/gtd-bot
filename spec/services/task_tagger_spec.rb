require 'rails_helper'

describe TaskTagger do
  let(:task_tagger) { TaskTagger.new(asana_client, tag_factory) }
  let(:asana_client) { instance_double('AsanaClient') }
  let(:tasks) { [task] }
  let(:tag_factory) { instance_double('TagFactory', find_or_create: tag) }
  let(:tag) { TagObject.new(asana_id: '1', name: 'test1') }

  describe '#perform' do
    subject { task_tagger.perform(tasks, tag_name) }

    context 'task already has specified tag' do
      let(:tag_name) { 'test1' }
      let(:task) { TaskObject.new(asana_id: '1', tags: [tag]) }

      it 'does not add tag to tasks' do
        expect(asana_client).not_to receive(:add_tag_to_task)
        subject
      end
    end

    context 'task does not have specified tag' do
      let(:tag_name) { 'test1' }
      let(:task) { TaskObject.new(asana_id: '1') }

      it 'adds tag to tasks' do
        expect(asana_client).to receive(:add_tag_to_task)
          .with(task.asana_id, tag.asana_id)
        subject
      end
    end
  end
end
