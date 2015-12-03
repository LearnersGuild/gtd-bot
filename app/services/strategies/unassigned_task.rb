module Strategies
  class UnassignedTask < BaseStrategy
    takes :projects_repository, :tasks_repository_factory, :tasks_assigner

    def perform
      projects_with_tasks = projects_repository.without_roles.with_tasks
      projects_with_tasks.each do |project|
        tasks = project.tasks
        tasks_repository = tasks_repository_factory.new(tasks)
        unassigned_tasks = tasks_repository.unassigned
        logger.info("Updating unassigned tasks for project #{project.name}...")
        tasks_assigner.perform(unassigned_tasks, project.owner_id)
        logger.info("Updating unassigned tasks finished")
      end
    end
  end
end
