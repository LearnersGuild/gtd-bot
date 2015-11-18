module Strategies
  class IndividualRole < BaseStrategy
    takes :projects_filter, :asana_client

    def perform
      if projects_filter.individual.empty?
        role_attributes = ProjectAttributes.new(ProjectObject::INDIVIDUAL_NAME)
        asana_client.create_project(role_attributes)
      end
    end
  end
end
