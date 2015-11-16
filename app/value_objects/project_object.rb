class ProjectObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :owner_id, String
  attribute :tasks, Array
  attribute :description, String
  IGNORED_PREFIX = '_'
  INDIVIDUAL_NAME = "@Individual"

  def a_role?
    name_start_with?(RoleObject::NAME_PREFIX)
  end

  def underscored?
    name_start_with?(IGNORED_PREFIX)
  end

  def individual?
    name.present? && name == INDIVIDUAL_NAME
  end

  private

  def name_start_with?(text)
    name.present? && name.start_with?(text)
  end
end
