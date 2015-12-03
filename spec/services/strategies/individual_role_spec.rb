require 'rails_helper'

module Strategies
  describe IndividualRole do
    let(:strategy) do
      IndividualRole.new(team, projects_repository, roles_repository)
    end
    let(:team) { TeamObject.new(asana_id: '1111') }
    let(:projects_repository) do
      double('ProjectsRepository',
             create: individual_project,
             individual: individual)
    end
    let(:roles_repository) do
      instance_double('RolesRepository', create_from_project: true)
    end

    let(:individual_project) do
      ProjectObject.new(name: ProjectObject::INDIVIDUAL_ROLE, asana_id: '7777')
    end

    describe '#perform' do
      subject { strategy.perform }

      context "&Individual role doesn't exist in Asana" do
        let(:individual) { [] }

        it 'creates &Individual role in Asana' do
          expect(projects_repository).to receive(:create)
          subject
        end

        it 'creates &Individual role in DB' do
          expect(roles_repository).to receive(:create_from_project)
            .with(individual_project)
          subject
        end
      end

      context "&Individual role exists in Asana" do
        let(:individual) { [individual_project] }

        it "doesn't create &Individual role" do
          expect(projects_repository).not_to receive(:create)
          subject
        end
      end
    end
  end
end
