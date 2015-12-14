require 'rails_helper'

describe Assigner do
  let(:assigner) do
    Assigner.new(repository)
  end
  let(:repository) { double('Repository') }
  let(:assignee_id) { double }
  let(:collection) { [object] }
  let(:object) { double(:object, id: double) }

  describe '#perform' do
    subject { assigner.perform(collection, assignee_id) }

    it 'assigns task' do
      expect(repository).to receive(:update)
        .with(object, assignee: assignee_id)
      subject
    end
  end
end
