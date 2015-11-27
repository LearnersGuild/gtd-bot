require 'rails_helper'

describe ProjectObject do
  describe "#a_role?" do
    subject { ProjectObject.new(name: name).a_role? }

    describe 'starts with "&"' do
      let(:name) { '&Awesome Developer' }

      it { expect(subject).to be true }
    end

    describe 'has "&" inside' do
      let(:name) { 'Setup&fix' }

      it { expect(subject).to be false }
    end

    describe 'does not have "&"' do
      let(:name) { 'Setup project' }

      it { expect(subject).to be false }
    end

    describe 'name is nil' do
      let(:name) { nil }

      it { expect(subject).to be false }
    end
  end

  describe "#linked_roles" do
    let(:project) { ProjectObject.new(description: description) }
    let(:description) { "" }
    let(:existing_roles) do
      [
        ProjectObject.new(asana_id: '7777')
      ]
    end

    subject { project.linked_role_ids(existing_roles) }

    before do
      expect(DescriptionParser).to receive(:new)
        .and_return(description_parser)
      expect(description_parser).to receive(:linked_ids)
        .with(description)
        .and_return(linked_ids)
    end

    let(:description_parser) do
      instance_double('DescriptionParser')
    end

    context "description contains a role" do
      let(:linked_ids) { ['7777'] }

      it { expect(subject).to eq(['7777']) }
    end

    context "description contains a link but not a role" do
      let(:linked_ids) { ['111'] }

      it { expect(subject).to eq([]) }
    end
  end
end
