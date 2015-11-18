require 'rails_helper'

describe TaskTagger do
  let(:task_tagger) { TaskTagger.new(asana_client, tag_factory) }
  let(:asana_client) { instance_double('AsanaClient') }
  let(:tasks) { [task] }
  let(:task) { TaskObject.new(asana_id: '1') }
  let(:tag_factory) { instance_double('TagFactory', find_or_create: tag) }
  let(:tag) { TagObject.new(asana_id: '1', name: 'test1') }

  describe '#perform' do
    subject { task_tagger.perform(tasks, tag_name) }
    let(:tag_name) { 'test1' }

    it 'adds tag to tasks' do
      expect(tag_factory).to receive(:find_or_create).with(tag_name)
        .and_return(tag)
      expect(asana_client).to receive(:add_tag_to_task)
        .with(task.asana_id, tag.asana_id)
      subject
    end
  end
end
