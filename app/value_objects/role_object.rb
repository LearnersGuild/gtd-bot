class RoleObject < BaseObject
  NAME_PREFIX = '@'

  attribute :glass_frog_id, Integer
  attribute :name, String
  attribute :asana_id, String
  attribute :asana_team_id, String

  def name_with_prefix
    NAME_PREFIX + name
  end
end
