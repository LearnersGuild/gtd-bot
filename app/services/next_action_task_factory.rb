class NextActionTaskFactory
  attr_accessor :asana_client
  NEW_ACTION_TITLE = "Please add next Action to project"

  def initialize(asana_client)
    self.asana_client = asana_client
  end

  def create(project)
    name = "#{NEW_ACTION_TITLE} @#{project.name}"
    attributes = { name: name, assignee: project.owner_id }
    asana_client.create_task(A9n.asana[:workspace_id], project.asana_id,
                             attributes)
  end
end
