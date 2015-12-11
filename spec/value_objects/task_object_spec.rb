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

    context 'tasks was modified before stale time' do
      let(:modified_at) { TaskObject::STALE_TIME.ago - 10.minutes }

      it 'returns true' do
        expect(task_object).to receive(:ignored_tags?)
        expect(task_object).to receive(:due_at_in_future?)
        expect(subject).to be_truthy
      end
    end

    context 'task was modified after stale time' do
      let(:modified_at) { TaskObject::STALE_TIME.ago + 10.minutes }

      it 'returns false' do
        expect(task_object).not_to receive(:ignored_tags?)
        expect(task_object).not_to receive(:due_at_in_future?)
        expect(subject).to be_falsey
      end
    end

    context 'modified_at is nil' do
      let(:modified_at) { nil }

      it 'returns false' do
        expect(task_object).not_to receive(:ignored_tags?)
        expect(task_object).not_to receive(:due_at_in_future?)
        expect(subject).to be_falsey
      end
    end
  end

  describe "#attributes_to_update_from_asana" do
    subject { task_object.attributes_to_update_from_asana }

    let(:task_object) do
      TaskObject.new(
        name: 'Name',
        modified_at: modified_at,
        project_ids: [],
        tags: []
      )
    end
    let(:name) { 'Name' }
    let(:modified_at) { DateTime.parse('10.07.1987') }

    context "ignores attribues that we don't get" \
             "while doing update call to Asana" do
      it { expect(subject[:project_ids]).to be nil }
      it { expect(subject[:tags]).to be nil }
    end

    context "returns other attributes" do
      it { expect(subject[:name]).to eq(name) }
      it { expect(subject[:modified_at]).to eq(modified_at) }
    end
  end
end
