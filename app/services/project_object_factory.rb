class ProjectObjectFactory < BaseService
  def build_from_asana(project)
    ProjectObject.new(
      asana_id: project.id,
      name: project.name,
      owner_id: project.owner['id'],
      description: project.notes
    )
  end
end
