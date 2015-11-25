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

  describe "#role_present?" do
    let(:project) { ProjectObject.new(description: description) }

    subject { project.role_present? }

    let(:role_link) { 'https://app.asana.com/0/7777/8888' }

    context "description is nil" do
      let(:description) { nil }

      it { expect(subject).to be false }
    end

    context "description is empty" do
      let(:description) { '' }

      it { expect(subject).to be false }
    end

    context "description contains a role" do
      let(:description) { "#{role_link} Description" }

      it { expect(subject).to be true }
    end

    context "description contains a role in the description content" do
      let(:description) { "Description #{role_link}" }

      it { expect(subject).to be true }
    end

    context "description does not contain a role" do
      let(:description) { "Description" }

      it { expect(subject).to be false }
    end
  end
end
