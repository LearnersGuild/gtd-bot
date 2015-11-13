class TaskDescriptionBuilder
  attr_accessor :description_parser

  def initialize(description_parser)
    self.description_parser = description_parser
  end

  def with_project_roles(task, project)
    description = description_parser.plain_description(task.description)
    roles = build_roles(task, project)
    "#{roles.join(' ')} #{description}"
  end

  def build_roles(task, project)
    project_roles = description_parser.all_roles(project.description)
    task_roles = description_parser.all_roles(task.description)
    prefix_roles = description_parser.prefix_roles(task.description)
    roles_in_sentences = task_roles - prefix_roles

    roles = (project_roles + task_roles).uniq
    roles - roles_in_sentences
  end
end
