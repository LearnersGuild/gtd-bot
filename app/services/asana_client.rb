class AsanaClient < BaseService
  attr_accessor :client, :factories_injector, :exception_handler

  RATE_LIMIT_SLEEP = 2
  RETRIES_COUNT = 3

  def initialize(factories_injector, exception_handler)
    self.client = Asana::Client.new do |c|
      c.authentication(:access_token, A9n.asana[:api_key])
    end
    self.factories_injector = factories_injector
    self.exception_handler = exception_handler
  end

  def create_project(workspace_id, team_id, project_attributes)
    attributes = project_attributes.merge(
      workspace: workspace_id,
      team: team_id
    )
    project = do_request { Asana::Project.create(client, attributes) }
    factories_injector.project_object_factory.build_from_asana(project)
  end

  def delete_project(project_id)
    project = build_project(project_id)
    do_request { project.delete }
  end

  def update_project(project_id, attributes)
    project = build_project(project_id)
    project = do_request { project.update(attributes) }
    factories_injector.project_object_factory.build_from_asana(project)
  end

  def teams(workspace_id)
    teams = do_request do
      Asana::Team.find_by_organization(client, organization: workspace_id)
    end
    teams.map do |t|
      users = t.users(options: { fields: [:email] })
        .map { |u| factories_injector.user_object_factory.from_asana(u) }
      factories_injector.team_object_factory.from_asana(t, users)
    end
  end

  def projects(workspace_id, team_id, archived = false)
    projects = do_request do
      Asana::Project.find_all(client,
                              workspace: workspace_id,
                              team: team_id,
                              archived: archived,
                              options: { fields: [:name, :owner, :notes] })
    end
    projects.map do |p|
      factories_injector.project_object_factory.build_from_asana(p)
    end
  end

  def create_task(workspace_id, project_id, attributes)
    merged_attributes = attributes.merge(
      workspace: workspace_id
    )
    merged_attributes =
      merged_attributes.merge(projects: [project_id]) if project_id
    task = do_request { Asana::Task.create(client, merged_attributes) }
    factories_injector.task_object_factory.build_from_asana(task)
  end

  def delete_task(task_id)
    task = build_task(task_id)
    do_request { task.delete }
  end

  def tasks_for_project(project_id)
    fields = [:name, :assignee, :notes, :modified_at, :tags, :due_at, :due_on,
              :completed, :projects]
    project = build_project(project_id)
    tasks = do_request { project.tasks(options: { fields: fields }) }
    tasks.map { |t| factories_injector.task_object_factory.build_from_asana(t) }
      .select(&:uncompleted?)
  end

  def update_task(task_id, attributes)
    task = build_task(task_id)
    do_request { task.update(attributes) }
  end

  def add_project_to_task(task_id, project_id)
    task = build_task(task_id)
    do_request { task.add_project(project: project_id) }
  end

  def all_tags(workspace_id)
    tags = do_request { Asana::Tag.find_all(client, workspace: workspace_id) }
    tags.map do |t|
      factories_injector.tag_object_factory.build_from_asana(t)
    end
  end

  def add_tag_to_task(task_id, tag_id)
    task = build_task(task_id)
    do_request { task.add_tag(tag: tag_id) }
  end

  def create_tag(workspace_id, attributes)
    merged_attributes = attributes.merge(workspace: workspace_id)
    tag = do_request { Asana::Tag.create(client, merged_attributes) }
    factories_injector.tag_object_factory.build_from_asana(tag)
  end

  def add_comment_to_task(task_id, text)
    task = build_task(task_id)
    do_request { task.add_comment(text: text) }
  end

  private

  def build_project(id)
    Asana::Project.new({ id: id }, { client: client })
  end

  def build_task(id)
    Asana::Task.new({ id: id }, { client: client })
  end

  def do_request(retries_count = RETRIES_COUNT, &block)
    block.call
  rescue Asana::Errors::InvalidRequest => exception
    exception_handler.perform(exception)
  rescue Asana::Errors::RateLimitEnforced => exception
    if retries_count > 0
      sleep RATE_LIMIT_SLEEP
      do_request(retries_count - 1, &block)
    end
    exception_handler.perform(exception)
  end
end
