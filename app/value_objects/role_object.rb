class RoleObject < BaseObject
  attribute :glass_frog_id, Integer
  attribute :name, String
  attribute :asana_id, String
  attribute :asana_team_id, String
  attribute :purpose, String, default: ""
  attribute :domains, Array, default: []
  attribute :accountabilities, Array, default: []
  attribute :users, Array, default: []

  DESCRIPTION_PATTERN =
    "Purpose: %s\nDomains: %s\nAccountabilities: %s\nUsers: %s"

  def name_with_prefix
    "#{ProjectObject::ROLE_PREFIX}#{name}"
  end

  def role_attributes
    description = DESCRIPTION_PATTERN %
                         [purpose,
                          relation_to_s(domains),
                          relation_to_s(accountabilities),
                          relation_to_s(users)]
    {
      name: name_with_prefix,
      notes: description,
      owner: users.first.try(:asana_id)
    }
  end

  private

  def relation_to_s(relation)
    relation.map(&:description).join(", ")
  end
end
