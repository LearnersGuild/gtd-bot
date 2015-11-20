require 'rails_helper'

describe TagFactory do
  let(:tag_factory) { TagFactory.new(asana_client, tags) }
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
        expect(asana_client).not_to receive(:create_tag)
        expect(subject).to eq(tag1)
        subject
      end
    end

    context 'tag does not exisit' do
      let(:name) { 'test3' }

      it 'returns tag' do
        expect(asana_client).to receive(:create_tag)
        expect(subject).to eq(new_tag)
        subject
      end

      context 'tag is not duplicated' do
        subject do
          tag_factory.find_or_create(name)
          tag_factory.find_or_create(name)
        end

        it 'returns tag and does not create same tag' do
          expect(asana_client).to receive(:create_tag).once
          expect(subject).to eq(new_tag)
          subject
        end
      end
    end
  end
end
