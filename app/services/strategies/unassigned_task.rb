module Strategies
  class UnassignedTask < BaseStrategy
    takes :projects_repository, :tasks_repository_factory, :assigner_factory,
      :parallel_iterator

    def perform
      projects_with_tasks = projects_repository.without_roles.with_tasks
      parallel_iterator.each(projects_with_tasks) do |project|
        tasks_repository = tasks_repository_factory.new(project.tasks)
        unassigned_tasks = tasks_repository.unassigned
        logger.info("Updating unassigned tasks for project #{project.name}...")
        tasks_assigner = assigner_factory.new(tasks_repository)
        tasks_assigner.perform(unassigned_tasks, project.owner_id)
        logger.info("Updating unassigned tasks finished")
      end
    end
  end
end
