require 'rails_helper'

describe SubtasksRepositoryFactory do
  let(:factory) { SubtasksRepositoryFactory.new(asana_client) }
  let(:asana_client) { double }

  describe "#new" do
    subject { factory.new(subtasks) }
    let(:subtasks) { [SubtaskObject.new] }

    it "creates SubtasksRepository with asana_client and collection" do
      collection = SubtasksCollection.new(subtasks)
      expect(SubtasksRepository).to receive(:new).with(asana_client, collection)
      subject
    end
  end
end

