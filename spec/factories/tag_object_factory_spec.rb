require 'rails_helper'

describe TagObjectFactory do
  let(:factory) { TagObjectFactory.new }

  describe "#build_from_asana" do
    subject { factory.build_from_asana(tag) }

    let(:tag) { double(id: '7777', name: 'tag') }

    it do
      expected = TagObject.new(asana_id: '7777', name: 'tag')
      expect(subject).to eq(expected)
    end
  end
end
