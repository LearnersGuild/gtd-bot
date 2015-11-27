require 'rails_helper'

describe DescriptionParser do
  let(:parser) { DescriptionParser.new }

  let(:role1) { 'https://app.asana.com/0/7777/7777' }
  let(:role2) { 'https://app.asana.com/0/8888/8888' }

  describe "#linked_ids" do
    subject { parser.linked_ids(description) }

    context "empty description" do
      let(:description) { "" }

      it { expect(subject).to eq([]) }
    end

    context "blank description" do
      let(:description) { nil }

      it { expect(subject).to eq([]) }
    end

    context "only role" do
      let(:description) { role1 }

      it { expect(subject).to eq(['7777']) }
    end

    context "only linked_ids" do
      let(:description) { "#{role1} #{role2}" }

      it { expect(subject).to eq(%w{7777 8888}) }
    end

    context "linked_ids with weird space" do
      let(:description) { "#{role1}\xC2\xA0#{role2}" }

      it { expect(subject).to eq(%w{7777 8888}) }
    end

    context "one role" do
      let(:description) { "#{role1} Plain Description" }

      it { expect(subject).to eq(['7777']) }
    end

    context "more linked_ids" do
      let(:description) { "#{role1} #{role2} Plain Description" }

      it { expect(subject).to eq(%w{7777 8888}) }
    end

    context "no linked_ids" do
      let(:description) { 'Plain Description' }

      it { expect(subject).to eq([]) }
    end

    context "'&' in the description" do
      let(:description) { "Notify #{role1} about this" }

      it { expect(subject).to eq(['7777']) }
    end
  end
end
