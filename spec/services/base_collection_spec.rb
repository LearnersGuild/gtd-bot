require 'rails_helper'

describe BaseCollection do
  class MyCollection < BaseCollection
  end

  class MyObject < BaseObject
    attribute :asana_id, String
  end

  let(:collection) { MyCollection.new([MyObject.new(asana_id: '7777')]) }

  describe "#add" do
    subject { collection.add(MyObject.new(asana_id: '8888')) }

    it do
      subject
      expected = [MyObject.new(asana_id: '7777'),
                  MyObject.new(asana_id: '8888')]
      expect(collection.items).to eq(expected)
    end

    it { expect(subject).to eq(MyObject.new(asana_id: '8888')) }
  end

  describe "#delete" do
    subject { collection.delete('7777') }

    it do
      subject
      expect(collection.items).to eq([])
    end
  end

  describe "#==" do
    let(:other) { MyCollection.new([MyObject.new(asana_id: '7777')]) }

    it { expect(collection).to eq(other) }

    context "different collection" do
      it { expect(collection).not_to eq(MyCollection.new) }
    end
  end

  describe "#select" do
    subject { collection.select { |o| o.asana_id == '7777' } }

    it do
      expected = MyCollection.new([MyObject.new(asana_id: '7777')])
      expect(subject).to eq(expected)
    end
  end

  describe "#reject" do
    subject { collection.reject { |o| o.asana_id == '7777' } }

    it { expect(subject).to eq(MyCollection.new) }
  end

  describe "#detect" do
    subject { collection.detect { |o| o.asana_id == '7777' } }

    it { expect(subject).to eq(MyObject.new(asana_id: '7777')) }
  end

  describe "#include?" do
    subject { collection.include?(MyObject.new(asana_id: '7777')) }

    it { expect(subject).to be true }
  end

  describe "#each" do
    subject { collection.each {} }

    it { expect(subject).to eq(collection.items) }
  end
end
