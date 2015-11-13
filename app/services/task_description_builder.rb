class TaskDescriptionBuilder
  attr_accessor :description_parser

  def initialize(description_parser)
    self.description_parser = description_parser
  end

  def with_project_roles(task, project)
    description = description_parser.plain_description(task.description)
    roles = description_parser.roles(task.description)
    project_roles = description_parser.roles(project.description)
    new_roles = project_roles + roles
    "#{new_roles.join(' ')} #{description}"
  end
end
