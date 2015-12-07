module Strategies
  class SpecialRole < BaseStrategy
    takes :team, :projects_repository, :roles_repository

    def perform
      logger.info("Creating #{name} role...")
      if exists?
        role_attributes = { name: name }
        project = projects_repository.create(role_attributes)
        roles_repository.create_from(project, team)
      end
      logger.info("#{name} role created")
    end

    private

    def exists?
      fail "method: #{__method__} is not implemented"
    end

    def name
      fail "method: #{__method__} is not implemented"
    end
  end
end
