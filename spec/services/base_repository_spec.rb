require 'rails_helper'

describe BaseRepository do
  class MyRepository < BaseRepository
    def default_collection
      MyCollection.new
    end
  end

  class MyCollection < BaseCollection
    def some_scope
      select { |o| o }
    end
  end

  class MyObject < BaseObject
  end

  let(:repository) { MyRepository.new(asana_client, collection) }
  let(:asana_client) { instance_double('AsanaClient') }
  let(:collection) { MyCollection.new([MyObject.new]) }

  describe "#initialize" do
    subject { repository }

    it { expect(subject.collection).to eq(collection) }

    context "collection not passed" do
      let(:repository) { MyRepository.new(asana_client) }

      it { expect(subject.collection).to eq(MyCollection.new) }
    end
  end

  describe "delegation do collection" do
    it "delegates missing methods to collection" do
      expected = MyCollection.new([MyObject.new])
      expect(repository.some_scope).to eq(expected)
    end
  end
end
