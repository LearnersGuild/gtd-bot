require 'rails_helper'

module Strategies
  describe EveryoneTask do
    let(:projects_repository) do
      double('ProjectsRepository',
             create: special_project,
             everyone: special)
    end
    it_behaves_like "SpecialRole", EveryoneRole, ProjectObject::EVERYONE_ROLE
  end
end
