require 'rails_helper'

describe TagsRepository do
  let(:repository) { TagsRepository.new(asana_client) }
  let(:asana_client) do
    instance_double('AsanaClient',
                    all_tags: tags,
                    create_tag: new_tag,
                    add_tag_to_task: true)
  end
  let(:tags) { [tag1, tag2] }
  let(:tag1) { TagObject.new(asana_id: '1', name: 'test1') }
  let(:tag2) { TagObject.new(asana_id: '2', name: 'test2') }
  let(:new_tag) { TagObject.new(asana_id: '3', name: 'test3') }

  describe "#initialize" do
    subject { repository }

    it "fetches all tags from Asana" do
      expect(asana_client).to receive(:all_tags)
      subject
    end
  end

  describe '#find_or_create' do
    subject { repository.find_or_create(name) }
    let(:tag) { TagObject.new(name: name) }
    let(:name) { 'tag' }

    context "tag found" do
      before do
        expect(repository).to receive(:find).and_return(tag)
      end

      it { expect(subject).to eq(tag) }
    end

    context "tag not found" do
      before do
        expect(repository).to receive(:find).and_return(nil)
      end

      it do
        expect(repository).to receive(:create).with(name)
        subject
      end
    end
  end

  describe "#find" do
    subject { repository.find(name) }

    context "tag found" do
      let(:name) { 'test1' }

      it { expect(subject).to eq(tag1) }
    end

    context "tag not found" do
      let(:name) { 'not existing tag' }

      it { expect(subject).to be nil }
    end
  end

  describe "#create" do
    subject { repository.create(name) }

    let(:name) { 'test3' }

    it "creates tag in Asana" do
      expect(asana_client).to receive(:create_tag)
        .with(ENV.fetch('ASANA_WORKSPACE_ID'), name: name)
      subject
    end

    it "creates tag in local cache" do
      subject
      expect(repository.find(name)).to eq(new_tag)
    end

    context "name is blank" do
      let(:name) { "" }

      it "creates tag in Asana" do
        expect(asana_client).not_to receive(:create_tag)
        subject
      end

      it "creates tag in local cache" do
        subject
        expect(repository.find(name)).to be nil
      end
    end
  end

  describe "#add_to_task" do
    subject { repository.add_to_task(task, tag) }
    let(:task) { TaskObject.new(asana_id: '7777') }
    let(:tag) { TagObject.new(asana_id: '8888', name: name) }
    let(:name) { 'tag' }

    it "updates Asana" do
      expect(asana_client).to receive(:add_tag_to_task)
        .with(task.asana_id, tag.asana_id)
      subject
    end

    it "updates local cache" do
      subject
      expect(task.tags.first).to eq(tag)
    end
  end
end
