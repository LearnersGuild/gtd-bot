require 'rails_helper'

module Strategies
  describe IndividualRole do
    let(:strategy) { IndividualRole.new(projects_filter, asana_client) }
    let(:asana_client) { instance_double('AsanaClient') }

    describe '#perform' do
      subject { strategy.perform }

      context "@Individual role doesn't exist in Asana" do
        let(:projects_filter) do
          instance_double('ProjectsFilter', individual: [])
        end

        it 'creates @Individual role' do
          expect(asana_client).to receive(:create_project)
          subject
        end
      end

      context "@Individual role exists in Asana" do
        let(:projects_filter) do
          instance_double('ProjectsFilter', individual: [individual_project])
        end
        let(:individual_project) do
          ProjectObject.new(name: Strategies::IndividualRole::INDIVIDUAL_NAME)
        end

        it "doesn't create @Individual role" do
          expect(asana_client).not_to receive(:create_project)
          subject
        end
      end
    end
  end
end
