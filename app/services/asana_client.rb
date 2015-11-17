class AsanaClient
  attr_accessor :client

  def initialize
    self.client = Asana::Client.new do |c|
      c.authentication(:access_token, A9n.asana[:api_key])
    end
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

  def projects(workspace_id, team_id)
    projects = Asana::Project.find_all(
      client,
      workspace: workspace_id,
      team: team_id,
      options: { fields: [:name, :owner, :notes] })
    projects.map do |p|
      ProjectObject.new(
        asana_id: p.id,
        name: p.name,
        owner_id: p.owner['id'],
        description: p.notes
      )
    end
  end

  def create_task(workspace_id, project_id, attributes)
    merged_attributes = attributes.merge(
      workspace: workspace_id,
      projects: [project_id]
    )
    Asana::Task.create(client, merged_attributes)
  end

  def tasks_for_project(project_id)
    fields = [:name, :assignee, :notes, :modified_at]
    build_project(project_id)
      .tasks(options: { fields: fields })
      .map do |t|
        tags = t.tags.map { |tg| TagObject.new(asana_id: tg.id, name: tg.name) }
        TaskObject.new(
          asana_id: t.id,
          name: t.name,
          assignee_id: t.assignee && t.assignee['id'],
          description: t.notes,
          modified_at: t.modified_at.to_date,
          tags: tags
        )
      end
  end

  def update_task(task_id, attributes)
    build_task(task_id).update(attributes)
  end

  private

  def build_project(id)
    Asana::Project.new({ id: id }, { client: client })
  end

  def build_task(id)
    Asana::Task.new({ id: id }, { client: client })
  end
end
