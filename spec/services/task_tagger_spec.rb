require 'rails_helper'

describe TaskTagger do
  let(:task_tagger) { TaskTagger.new(tags_repository, parallel_iterator) }
  let(:parallel_iterator) { ParallelIterator.new }
  let(:tags_repository) do
    instance_double('TagsRepository', find_or_create: tag)
  end
  let(:tasks) { [task] }
  let(:tag) { TagObject.new(asana_id: '1', name: 'test1') }

  describe '#perform' do
    subject { task_tagger.perform(tasks, tag_name) }

    let(:tag_name) { 'test1' }
    let(:task) { TaskObject.new(asana_id: '1') }

    it 'adds tag to tasks' do
      expect(tags_repository).to receive(:add_to_task)
        .with(task, tag)
      subject
    end
  end
end
