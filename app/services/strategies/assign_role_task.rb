module Strategies
  class AssignRoleTask < BaseStrategy
    takes :projects_filter, :assign_role_task_factory

    def perform
      projects_without_roles = projects_filter.without_roles_assigned
      projects_without_roles.each do |project|
        assign_role_task_factory.create(project)
      end
    end
  end
end
