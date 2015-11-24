require 'rails_helper'

describe DescriptionParser do
  let(:parser) { DescriptionParser.new }
  let(:role1) { 'https://app.asana.com/0/7777/8888' }
  let(:role2) { 'https://app.asana.com/0/7777/9999' }

  describe "#plain_description" do
    subject { parser.plain_description(description) }

    context "empty description" do
      let(:description) { "" }

      it { expect(subject).to eq('') }
    end

    context "nil description" do
      let(:description) { nil }

      it { expect(subject).to eq('') }
    end

    context "only role" do
      let(:description) { role1 }

      it { expect(subject).to eq('') }
    end

    context "only roles" do
      let(:description) { "#{role1} #{role2}" }

      it { expect(subject).to eq('') }
    end

    context "roles with weird space" do
      let(:description) { "#{role1}\xC2\xA0#{role2}" }

      it { expect(subject).to eq('') }
    end

    context "one role" do
      let(:description) { "#{role1} Plain Description" }

      it { expect(subject).to eq('Plain Description') }
    end

    context "more roles" do
      let(:description) { "#{role1} #{role2} Plain Description" }

      it { expect(subject).to eq('Plain Description') }
    end

    context "no roles" do
      let(:roles) { [] }
      let(:description) { 'Plain Description' }

      it { expect(subject).to eq('Plain Description') }
    end

    context "role in the description" do
      let(:description) { "Notify #{role1} about this" }

      it { expect(subject).to eq("Notify #{role1} about this") }
    end
  end

  shared_examples_for "roles" do
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

      it { expect(subject).to eq([role1]) }
    end

    context "only roles" do
      let(:description) { "#{role1} #{role2}" }

      it { expect(subject).to eq([role1, role2]) }
    end

    context "roles with weird space" do
      let(:description) { "#{role1}\xC2\xA0#{role2}" }

      it { expect(subject).to eq([role1, role2]) }
    end

    context "one role" do
      let(:description) { "#{role1} Plain Description" }

      it { expect(subject).to eq([role1]) }
    end

    context "more roles" do
      let(:description) { "#{role1} #{role2} Plain Description" }

      it { expect(subject).to eq([role1, role2]) }
    end

    context "no roles" do
      let(:description) { 'Plain Description' }

      it { expect(subject).to eq([]) }
    end
  end

  describe "#all_roles" do
    subject { parser.all_roles(description) }

    it_behaves_like "roles"

    context "'@' in the description" do
      let(:description) { "Notify #{role1} about this" }

      it { expect(subject).to eq([role1]) }
    end
  end

  describe "#prefix_roles" do
    subject { parser.prefix_roles(description) }

    it_behaves_like "roles"

    context "'@' in the description" do
      let(:description) { "Notify #{role1} about this" }

      it { expect(subject).to eq([]) }
    end
  end
end
