require 'rails_helper'

describe TagFactory do
  let(:tag_factory) { TagFactory.new(asana_client) }
  let(:asana_client) do
    instance_double('AsanaClient', all_tags: tags, create_tag: new_tag)
  end
  let(:tags) { [tag1, tag2] }
  let(:tag1) { TagObject.new(asana_id: '1', name: 'test1') }
  let(:tag2) { TagObject.new(asana_id: '2', name: 'test2') }
  let(:new_tag) { TagObject.new(asana_id: '3', name: 'test3') }

  describe '#find_or_create' do
    subject { tag_factory.find_or_create(name) }

    context 'tag already exisits' do
      let(:name) { 'test1' }

      it 'returns tag' do
        expect(tag_factory).not_to receive(:create)
        expect(asana_client).not_to receive(:create_tag)
        expect(tag_factory).to receive(:find).with(name).and_return(tag1)
        expect(subject).to eq(tag1)
        subject
      end
    end

    context 'tag does not exisit' do
      let(:name) { 'test3' }

      it 'returns tag' do
        expect(tag_factory).to receive(:find).with(name).and_return(nil)
        expect(tag_factory).to receive(:create).with(name).and_return(new_tag)
        expect(subject).to eq(new_tag)
        subject
      end
    end
  end
end
