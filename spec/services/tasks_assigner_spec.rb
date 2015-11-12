require 'rails_helper'

describe TasksAssigner do
  let(:tasks_assigner) { TasksAssigner.new(asana_client) }
  let(:asana_client) { instance_double('AsanaClient') }
  let(:assignee_id) { double }
  let(:tasks) { [task] }
  let(:task) { TaskObject.new(id: double) }

  describe '#perform' do
    subject { tasks_assigner.perform(tasks, assignee_id) }

    it 'assigns task' do
      expect(asana_client).to receive(:update_task)
      subject
    end
  end
end
