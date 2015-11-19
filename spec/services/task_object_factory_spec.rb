require 'rails_helper'

describe TaskObjectFactory do
  let(:task_object_factory) { TaskObjectFactory.new }
  describe 'build_from_asana' do
    subject { task_object_factory.build_from_asana(task) }
    let(:task) do
      double(
        id: id,
        name: name,
        assignee: assignee,
        notes: notes,
        modified_at: modified_at,
        due_at: due_at,
        due_on: due_on,
        tags: tags
      )
    end
    let(:id) { '1' }
    let(:name) { 'name' }
    let(:assignee) { { "id" => assignee_id } }
    let(:assignee_id) { '2' }
    let(:notes) { 'description' }
    let(:modified_at) { 1.week.ago.to_s }
    let(:expected_modified_at) { DateTime.parse(modified_at) }
    let(:tags) { [double(id: tag_id, name: tag_name)] }
    let(:expected_tags) { [TagObject.new(asana_id: tag_id, name: tag_name)] }
    let(:tag_id) { '3' }
    let(:tag_name) { 'tag_name' }

    context 'task does not have due_at and due_on' do
      let(:due_on) { nil }
      let(:due_at) { nil }
      let(:expected_due_at) { nil }
      let(:expected_task_object) do
        TaskObject.new(
          asana_id: id,
          name: name,
          assignee_id: assignee_id,
          description: notes,
          modified_at: expected_modified_at,
          due_at: expected_due_at,
          tags: expected_tags
        )
      end

      it 'returns task object' do
        expect(subject).to eq(expected_task_object)
      end
    end

    context 'task does not have due_at and has due_on' do
      let(:due_on) { 1.day.from_now.to_date.to_s }
      let(:due_at) { nil }
      let(:expected_due_at) { DateTime.parse(due_on) }
      let(:expected_task_object) do
        TaskObject.new(
          asana_id: id,
          name: name,
          assignee_id: assignee_id,
          description: notes,
          modified_at: expected_modified_at,
          due_at: expected_due_at,
          tags: expected_tags
        )
      end

      it 'returns task object' do
        expect(subject).to eq(expected_task_object)
      end
    end

    context 'task has due_at and does not have due_on' do
      let(:due_on) { nil }
      let(:due_at) { 1.day.from_now.to_s }
      let(:expected_due_at) { DateTime.parse(due_at) }
      let(:expected_task_object) do
        TaskObject.new(
          asana_id: id,
          name: name,
          assignee_id: assignee_id,
          description: notes,
          modified_at: expected_modified_at,
          due_at: expected_due_at,
          tags: expected_tags
        )
      end

      it 'returns task object' do
        expect(subject).to eq(expected_task_object)
      end
    end
  end
end
