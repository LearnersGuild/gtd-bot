require 'rails_helper'

describe TaskObject do
  describe '#assigned_to?' do
    subject { task_object.assigned_to?(id) }
    let(:task_object) { TaskObject.new(assignee_id: assignee_id) }

    context 'task is assigned to specified user' do
      let(:id) { '1' }
      let(:assignee_id) { id }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'task is not assigned to specified user' do
      let(:id) { '1' }
      let(:assignee_id) { '2' }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#ignored_tags?' do
    subject { task_object.ignored_tags? }
    let(:ignored_tag) do
      TagObject.new(name: TaskObject::IGNORED_TAGS_NAMES.sample)
    end
    let(:other_tag) { TagObject.new(name: 'test') }

    context 'task has ignored tags' do
      let(:task_object) { TaskObject.new(tags: [ignored_tag, other_tag]) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'task does not have ignored tags' do
      let(:task_object) { TaskObject.new(tags: [other_tag]) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#due_at_in_future?' do
    subject { task_object.due_at_in_future? }
    let(:task_object) { TaskObject.new(due_at: due_at) }

    context 'task has due_at in future' do
      let(:due_at) { 10.minutes.from_now }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'task does not have due_at in future' do
      let(:due_at) { 10.minutes.ago }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#stale_task?' do
    subject { task_object.stale_task? }
    let(:task_object) { TaskObject.new(modified_at: modified_at) }

    context 'task is stale' do
      let(:modified_at) { TaskObject::STALE_TIME - 10.minutes }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'task does not have due_at in future' do
      let(:modified_at) { TaskObject::STALE_TIME + 10.minutes }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end
end