class ProjectObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :owner_id, String
  attribute :tasks, Array

  def a_role?
    name.present? && name.start_with?("@")
  end
end
