require 'rails_helper'

describe TaskTagger do
  let(:task_tagger) do
    TaskTagger.new(tags_repository, parallel_iterator, strategies_repository)
  end
  let(:parallel_iterator) { ParallelIterator.new }
  let(:tags_repository) do
    instance_double('TagsRepository', find_or_create: tag)
  end
  let(:strategies_repository) do
    instance_double('StrategiesRepository',
                    register_performing: true,
                    already_performed?: false)
  end
  let(:task) { TaskObject.new(asana_id: '1') }
  let(:tasks) { [task] }
  let(:tag) { TagObject.new(asana_id: '1', name: 'test1') }

  describe '#perform' do
    subject { task_tagger.perform(tasks, tag_name) }

    let(:tag_name) { 'test1' }

    it 'adds tag to tasks' do
      expect(tags_repository).to receive(:add_to_task)
        .with(task, tag)
      subject
    end

    context "tag already present" do
      let(:task) { TaskObject.new(asana_id: '1', tags: [tag]) }

      it 'does not add tag to tasks' do
        expect(tags_repository).not_to receive(:add_to_task)
          .with(task, tag)
        subject
      end
    end

    context "strategy already performed" do
      it 'does not add tag to tasks' do
        expect(strategies_repository).to receive(:already_performed?)
          .and_return(true)
        expect(tags_repository).not_to receive(:add_to_task)
          .with(task, tag)
        subject
      end
    end
  end
end
