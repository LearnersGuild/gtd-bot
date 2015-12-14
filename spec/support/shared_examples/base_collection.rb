shared_examples_for "BaseCollection" do |collection_class, object_class|
  let(:collection) do
    collection_class.new([object])
  end
  let(:object) { object_class.new(asana_id: '7777') }

  describe "#add" do
    subject { collection.add(object_class.new(asana_id: '8888')) }

    it do
      subject
      expected = [object_class.new(asana_id: '7777'),
                  object_class.new(asana_id: '8888')]
      expect(collection.items).to eq(expected)
    end

    it { expect(subject).to eq(object_class.new(asana_id: '8888')) }
  end

  describe "#delete" do
    subject { collection.delete('7777') }

    it do
      subject
      expect(collection.items).to eq([])
    end
  end

  describe "#==" do
    let(:other) { collection_class.new([object_class.new(asana_id: '7777')]) }

    it { expect(collection).to eq(other) }

    context "different collection" do
      it { expect(collection).not_to eq(collection_class.new) }
    end
  end

  describe "#to_a" do
    it { expect(collection.to_a).to eq(collection.items) }
  end

  describe "#empty?" do
    subject { collection.empty? }

    it { expect(subject).to be false }

    context "collection is empty" do
      let(:collection) { collection_class.new }

      it { expect(subject).to be true }
    end
  end

  describe "#select" do
    subject { collection.select { |o| o.asana_id == '7777' } }

    it do
      expected = collection_class.new([object_class.new(asana_id: '7777')])
      expect(subject).to eq(expected)
    end
  end

  describe "#reject" do
    subject { collection.reject { |o| o.asana_id == '7777' } }

    it { expect(subject).to eq(collection_class.new) }
  end

  describe "#detect" do
    subject { collection.detect { |o| o.asana_id == '7777' } }

    it { expect(subject).to eq(object_class.new(asana_id: '7777')) }
  end

  describe "#include?" do
    subject { collection.include?(object_class.new(asana_id: '7777')) }

    it { expect(subject).to be true }
  end

  describe "#each" do
    subject { collection.each {} }

    it { expect(subject).to eq(collection.items) }
  end
end
