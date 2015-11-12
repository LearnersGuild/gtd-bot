require 'rails_helper'

module Strategies
  describe IndividualRole do
    let(:strategy) { IndividualRole.new(projects_filter, asana_client) }
    let(:projects_filter) do
      instance_double('ProjectsFilter', individual: [])
    end
    let(:asana_client) { instance_double('AsanaClient') }

    describe '#perform' do
      subject { strategy.perform }

      it 'creates @Individual role' do
        expect(asana_client).to receive(:create_project)
        subject
      end
    end
  end
end
