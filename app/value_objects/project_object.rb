class ProjectObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :owner_id, String
  attribute :tasks, Array
  attribute :description, String
  IGNORED_PREFIX = '_'
  ROLE_PREFIX = '&'
  INDIVIDUAL_NAME = "Individual"
  EVERYONE_NAME = "Everyone"
  INDIVIDUAL_ROLE = "#{ROLE_PREFIX}#{INDIVIDUAL_NAME}"
  EVERYONE_ROLE = "#{ROLE_PREFIX}#{EVERYONE_NAME}"
  PROJECT_LINK_BASE = "https://app.asana.com/0"
  SPECIAL_NAMES = [INDIVIDUAL_NAME, EVERYONE_NAME]

  def a_role?
    name_start_with?(ROLE_PREFIX)
  end

  def underscored?
    name_start_with?(IGNORED_PREFIX)
  end

  def individual?
    with_name?(INDIVIDUAL_ROLE)
  end

  def everyone?
    with_name?(EVERYONE_ROLE)
  end

  def link
    "#{PROJECT_LINK_BASE}/#{asana_id}"
  end

  def linked_role_ids(existing_roles)
    parser = DescriptionParser.new
    linked_ids = parser.linked_ids(description)
    linked_ids & existing_roles.map(&:asana_id)
  end

  private

  def name_start_with?(text)
    name.present? && name.start_with?(text)
  end

  def with_name?(expected_name)
    name.present? && name == expected_name
  end
end
