require 'rails_helper'

describe DescriptionParser do
  let(:parser) { DescriptionParser.new }

  describe "#plain_description" do
    subject { parser.plain_description(description) }

    context "one role" do
      let(:description) { '@Developer Task Description' }

      it { expect(subject).to eq('Task Description') }
    end

    context "more roles" do
      let(:description) { '@Tester @Developer Task Description' }

      it { expect(subject).to eq('Task Description') }
    end

    context "no roles" do
      let(:description) { 'Task Description' }

      it { expect(subject).to eq('Task Description') }
    end

    context "'@' in the description" do
      let(:description) { '@Developer Setup gtd-bot@example.org email' }

      it { expect(subject).to eq('Setup gtd-bot@example.org email') }
    end
  end

  describe "#roles" do
    subject { parser.roles(description) }

    context "one role" do
      let(:description) { '@Developer Task Description' }

      it { expect(subject).to eq(['@Developer']) }
    end

    context "more roles" do
      let(:description) { '@Tester @Developer Task Description' }

      it { expect(subject).to eq(['@Tester', '@Developer']) }
    end

    context "no roles" do
      let(:description) { 'Task Description' }

      it { expect(subject).to eq([]) }
    end

    context "'@' in the description" do
      let(:description) { '@Developer Setup gtd-bot@example.org email' }

      it { expect(subject).to eq(['@Developer']) }
    end
  end
end
