module Strategies
  class IndividualRole < BaseService
    takes :projects_filter, :asana_client

    INDIVIDUAL_NAME = "@Individual"

    def perform
      if projects_filter.individual.empty?
        role_attributes = ProjectAttributes.new(INDIVIDUAL_NAME)
        asana_client.create_project(role_attributes)
      end
    end
  end
end
