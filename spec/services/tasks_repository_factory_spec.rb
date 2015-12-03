require 'rails_helper'

describe TasksRepositoryFactory do
  let(:factory) { TasksRepositoryFactory.new(asana_client) }
  let(:asana_client) { double }

  describe "#new" do
    subject { factory.new(collection) }
    let(:collection) { TasksCollection.new }

    it "creates TasksRepository with asana_client and collection" do
      expect(TasksRepository).to receive(:new).with(asana_client, collection)
      subject
    end
  end
end

