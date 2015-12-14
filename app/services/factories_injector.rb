class FactoriesInjector < BaseService
  takes :team_object_factory, :project_object_factory,
    :task_object_factory, :tag_object_factory, :user_object_factory,
    :subtask_object_factory
end
