module Strategies
  class UnassignedSubtask < BaseStrategy
    takes :projects_repository, :tasks_repository_factory,
      :subtasks_repository_factory, :assigner_factory,
      :subtasks_owner_setter_factory, :parallel_iterator

    def perform
      projects_with_tasks = projects_repository.with_tasks
      projects_with_tasks.each do |project|
        tasks_repository = tasks_repository_factory.new(project.tasks)
        subtasks_owner_setter =
          subtasks_owner_setter_factory.new(subtasks_repository_factory,
                                            assigner_factory,
                                            parallel_iterator)
        subtasks_owner_setter.perform(tasks_repository)
      end
    end
  end
end
