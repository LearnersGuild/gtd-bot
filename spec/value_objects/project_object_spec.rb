require 'rails_helper'

describe ProjectObject do
  describe "#a_role?" do
    subject { ProjectObject.new(name: name).a_role? }

    describe 'starts with "@"' do
      let(:name) { '@Awesome Developer' }

      it { expect(subject).to be true }
    end

    describe 'has "@" inside' do
      let(:name) { 'Setup gtd-bot@example.org email' }

      it { expect(subject).to be false }
    end

    describe 'does not have "@"' do
      let(:name) { 'Setup project' }

      it { expect(subject).to be false }
    end

    describe 'name is nil' do
      let(:name) { nil }

      it { expect(subject).to be false }
    end
  end
end
