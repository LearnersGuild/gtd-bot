require 'rails_helper'

module Strategies
  describe IndividualRole do
    let(:strategy) do
      IndividualRole.new(team, projects_collection, asana_client)
    end
    let(:team) { TeamObject.new(asana_id: '1111') }
    let(:asana_client) do
      instance_double('AsanaClient', create_project: individual_project)
    end

    let(:individual_project) do
      ProjectObject.new(name: ProjectObject::INDIVIDUAL_ROLE, asana_id: '7777')
    end

    describe '#perform' do
      subject { strategy.perform }

      context "&Individual role doesn't exist in Asana" do
        let(:projects_collection) do
          instance_double('ProjectsCollection', individual: [])
        end

        it 'creates &Individual role in Asana' do
          expect(asana_client).to receive(:create_project)
          subject
        end

        it 'creates &Individual role in DB' do
          subject
          individual_role = Role.where(
            name: ProjectObject::INDIVIDUAL_NAME,
            asana_team_id: team.asana_id
          )
          expect(individual_role).not_to be_blank
        end
      end

      context "&Individual role exists in Asana" do
        let(:projects_collection) do
          instance_double('ProjectsCollection',
                          individual: [individual_project])
        end

        it "doesn't create &Individual role" do
          expect(asana_client).not_to receive(:create_project)
          subject
        end
      end
    end
  end
end
