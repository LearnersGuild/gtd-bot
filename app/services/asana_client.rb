class AsanaClient < BaseService
  attr_accessor :client, :team_object_factory

  def initialize(team_object_factory)
    self.client = Asana::Client.new do |c|
      c.authentication(:access_token, A9n.asana[:api_key])
    end
    self.team_object_factory = team_object_factory
  end

  def create_project(attributes)
    Asana::Project.create(client, attributes)
  end

  def delete_project(project_id)
    build_project(project_id).delete
  end

  def update_project(project_id, attributes)
    build_project(project_id).update(attributes)
  end

  def teams(workspace_id)
    teams = Asana::Team.find_by_organization(client, organization: workspace_id)
    teams.map { |t| team_object_factory.from_asana(t) }
  end

  def projects(workspace_id, team_id)
    projects = Asana::Project.find_all(
      client,
      workspace: workspace_id,
      team: team_id,
      options: { fields: [:name, :owner, :notes] })
    projects.map { |p| ProjectObjectFactory.new.build_from_asana(p) }
  end

  def create_task(workspace_id, project_id, attributes)
    merged_attributes = attributes.merge(
      workspace: workspace_id,
      projects: [project_id]
    )
    Asana::Task.create(client, merged_attributes)
  end

  def tasks_for_project(project_id)
    fields = [:name, :assignee, :notes, :modified_at, :tags, :due_at, :due_on]
    build_project(project_id)
      .tasks(options: { fields: fields })
      .map { |t| TaskObjectFactory.new.build_from_asana(t) }
  end

  def update_task(task_id, attributes)
    build_task(task_id).update(attributes)
  end

  def all_tags(workspace_id)
    Asana::Tag.find_all(client, workspace: workspace_id).map do |t|
      TagObject.new(asana_id: t.id, name: t.name)
    end
  end

  def add_tag_to_task(task_id, tag_id)
    build_task(task_id).add_tag(tag: tag_id)
  end

  def create_tag(workspace_id, attributes)
    merged_attributes = attributes.merge(workspace: workspace_id)
    Asana::Tag.create(client, merged_attributes)
  end

  private

  def build_project(id)
    Asana::Project.new({ id: id }, { client: client })
  end

  def build_task(id)
    Asana::Task.new({ id: id }, { client: client })
  end
end
