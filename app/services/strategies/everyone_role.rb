module Strategies
  class EveryoneRole < SpecialRole
    private

    def empty?
      projects_repository.everyone.empty?
    end

    def name
      ProjectObject::EVERYONE_ROLE
    end
  end
end
