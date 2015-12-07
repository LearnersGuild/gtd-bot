module Strategies
  class EveryoneRole < SpecialRole
    private

    def exists?
      projects_repository.everyone.empty?
    end

    def name
      ProjectObject::EVERYONE_ROLE
    end
  end
end
