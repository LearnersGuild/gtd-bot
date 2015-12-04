shared_examples_for \
  "BaseRepository" do |repository_class, collection_class, object_class|
  let(:repository) { repository_class.new(asana_client, collection) }
  let(:asana_client) { instance_double('AsanaClient') }
  let(:collection) { collection_class.new([object_class.new]) }

  describe "#initialize" do
    subject { repository }

    it { expect(subject.collection).to eq(collection) }

    context "collection not passed" do
      let(:repository) { repository_class.new(asana_client) }

      it { expect(subject.collection).to eq(collection_class.new) }
    end
  end

  describe "delegation do collection" do
    it "delegates missing methods to collection" do
      expected = collection_class.new([object_class.new])
      expect(repository.select { |o| o }).to eq(expected)
    end
  end
end
