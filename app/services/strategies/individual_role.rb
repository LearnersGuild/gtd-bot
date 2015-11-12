module Strategies
  class IndividualRole
    attr_accessor :projects_filter, :asana_client
    INDIVIDUAL_NAME = "@Individual"

    def initialize(projects_filter, asana_client)
      self.projects_filter = projects_filter
      self.asana_client = asana_client
    end

    def perform
      if projects_filter.individual.empty?
        role_attributes = ProjectAttributes.new(INDIVIDUAL_NAME)
        asana_client.create_project(role_attributes)
      end
    end
  end
end
