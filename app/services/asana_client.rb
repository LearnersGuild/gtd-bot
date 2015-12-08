class AsanaClient < BaseService
  attr_accessor :client, :factories_injector

  def initialize(factories_injector)
    self.client = Asana::Client.new do |c|
      c.authentication(:access_token, A9n.asana[:api_key])
    end
    self.factories_injector = factories_injector
  end

  def create_project(workspace_id, team_id, project_attributes)
    attributes = project_attributes.merge(
      workspace: workspace_id,
      team: team_id
    )
    project = Asana::Project.create(client, attributes)
    factories_injector.project_object_factory.build_from_asana(project)
  end

  def delete_project(project_id)
    project = build_project(project_id)
    project.delete
  end

  def update_project(project_id, attributes)
    project = build_project(project_id).update(attributes)
    factories_injector.project_object_factory.build_from_asana(project)
  end

  def teams(workspace_id)
    teams = Asana::Team.find_by_organization(client, organization: workspace_id)
    teams.map do |t|
      users = t.users(options: { fields: [:email] })
        .map { |u| factories_injector.user_object_factory.from_asana(u) }
      factories_injector.team_object_factory.from_asana(t, users)
    end
  end

  def projects(workspace_id, team_id, archived = false)
    projects = Asana::Project.find_all(
      client,
      workspace: workspace_id,
      team: team_id,
      archived: archived,
      options: { fields: [:name, :owner, :notes] })
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
    task = Asana::Task.create(client, merged_attributes)
    factories_injector.task_object_factory.build_from_asana(task)
  end

  def delete_task(task_id)
    task = build_task(task_id)
    task.delete
  end

  def tasks_for_project(project_id)
    fields = [:name, :assignee, :notes, :modified_at, :tags, :due_at, :due_on,
              :completed]
    build_project(project_id)
      .tasks(options: { fields: fields })
      .map { |t| factories_injector.task_object_factory.build_from_asana(t) }
      .select(&:uncompleted?)
  end

  def update_task(task_id, attributes)
    build_task(task_id).update(attributes)
  end

  def add_project_to_task(task_id, project_id)
    build_task(task_id).add_project(project: project_id)
  end

  def all_tags(workspace_id)
    Asana::Tag.find_all(client, workspace: workspace_id).map do |t|
      factories_injector.tag_object_factory.build_from_asana(t)
    end
  end

  def add_tag_to_task(task_id, tag_id)
    build_task(task_id).add_tag(tag: tag_id)
  end

  def create_tag(workspace_id, attributes)
    merged_attributes = attributes.merge(workspace: workspace_id)
    tag = Asana::Tag.create(client, merged_attributes)
    factories_injector.tag_object_factory.build_from_asana(tag)
  end

  def add_comment_to_task(task_id, text)
    build_task(task_id).add_comment(text: text)
  end

  private

  def build_project(id)
    Asana::Project.new({ id: id }, { client: client })
  end

  def build_task(id)
    Asana::Task.new({ id: id }, { client: client })
  end
end
