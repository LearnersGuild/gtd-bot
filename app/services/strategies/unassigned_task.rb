module Strategies
  class UnassignedTask < BaseStrategy
    takes :projects_filter, :tasks_filter_factory, :tasks_assigner

    def perform
      projects_with_tasks = projects_filter.without_roles.with_tasks
      projects_with_tasks.each do |project|
        tasks = project.tasks
        tasks_filter = tasks_filter_factory.new(tasks)
        unassigned_tasks = tasks_filter.unassigned
        logger.info("Updating unassigned tasks...")
        tasks_assigner.perform(unassigned_tasks, project.owner_id)
        logger.info("Updating unassigned tasks finished")
      end
    end
  end
end
