require 'rails_helper'

module Strategies
  describe IndividualRole do
    let(:projects_repository) do
      double('ProjectsRepository',
             create: special_project,
             individual: special)
    end
    it_behaves_like "SpecialRole", IndividualRole,
      ProjectObject::INDIVIDUAL_ROLE, :individual
  end
end
