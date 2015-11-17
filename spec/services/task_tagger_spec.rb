require 'rails_helper'

describe TaskTagger do
  let(:task_tagger) { TaskTagger.new(asana_client, tag_factory) }
  let(:asana_client) do
    instance_double('AsanaClient', all_tags: tags)
  end
  let(:tasks) { [task] }
  let(:task) { TaskObject.new(asana_id: '1') }
  let(:tag_factory) { instance_double('TagFactory', perform: tag3) }
  let(:tags) { [tag1, tag2] }
  let(:tag1) { TagObject.new(asana_id: '1', name: 'test1') }
  let(:tag2) { TagObject.new(asana_id: '2', name: 'test2') }
  let(:tag3) { TagObject.new(asana_id: '3', name: 'test3') }

  describe '#perform' do
    subject { task_tagger.perform(tasks, tag_name) }

    context 'tag already exists' do
      let(:tag_name) { 'test1' }

      it 'adds tag to tasks' do
        expect(asana_client).to receive(:add_tag_to_task)
        .with(task.asana_id, tag1.asana_id)
        expect(tag_factory).to_not receive(:perform)
        subject
      end
    end

    context 'tag does not exist' do
      let(:tag_name) { 'test3' }

      it 'adds tag to tasks' do
        expect(asana_client).to receive(:add_tag_to_task)
        .with(task.asana_id, tag3.asana_id)
        expect(tag_factory).to receive(:perform).with(tag_name)
        subject
      end
    end
  end
end
