module Strategies
  class IndividualRole < SpecialRole
    private

    def empty?
      projects_repository.individual.empty?
    end

    def name
      ProjectObject::INDIVIDUAL_ROLE
    end
  end
end
