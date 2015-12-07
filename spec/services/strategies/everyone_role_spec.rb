require 'rails_helper'

module Strategies
  describe EveryoneTask do
    let(:strategy) do
      EveryoneRole.new(team, projects_repository, roles_repository)
    end
    let(:team) { TeamObject.new(asana_id: '1111') }
    let(:projects_repository) do
      double('ProjectsRepository',
             create: everyone_project,
             everyone: everyone)
    end
    let(:roles_repository) do
      instance_double('RolesRepository', create_from: true)
    end

    let(:everyone_project) do
      ProjectObject.new(name: ProjectObject::EVERYONE_ROLE, asana_id: '7777')
    end

    describe '#perform' do
      subject { strategy.perform }

      context "&Everyone role doesn't exist in Asana" do
        let(:everyone) { [] }

        it 'creates &Everyone role in Asana' do
          expect(projects_repository).to receive(:create)
          subject
        end

        it 'creates &Everyone role in DB' do
          expect(roles_repository).to receive(:create_from)
            .with(everyone_project, team)
          subject
        end
      end

      context "&Everyone role exists in Asana" do
        let(:everyone) { [everyone_project] }

        it "doesn't create &Everyone role" do
          expect(projects_repository).not_to receive(:create)
          subject
        end
      end
    end
  end
end
