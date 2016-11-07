class RoleObject < BaseObject
  attribute :glass_frog_id, Integer
  attribute :glass_frog_circle_name, String
  attribute :name, String
  attribute :asana_id, String
  attribute :asana_team_id, String
  attribute :purpose, String, default: ""
  attribute :domains, Array, default: []
  attribute :accountabilities, Array, default: []
  attribute :users, Array, default: []

  DESCRIPTION_PATTERN =
    "Purpose:\n%s\n\nDomains:\n%s\n\nAccountabilities:\n%s\n\nUsers:\n%s"

  HOLACRACY_NAMES = ["Lead Link",
                     "Facilitator",
                     "Secretary",
                     "Governor",
                     "Rep Link"]

  def name_with_prefix
    "#{ProjectObject::ROLE_PREFIX}#{name}"
  end

  def asana_name
    if holacracy_role?
      "#{name_with_prefix} #{glass_frog_circle_name}"
    else
      name_with_prefix
    end
  end

  def holacracy_role?
    HOLACRACY_NAMES.include?(name)
  end

  def role_attributes
    description = DESCRIPTION_PATTERN %
                         [purpose,
                          relation_to_s(domains),
                          relation_to_s(accountabilities),
                          relation_to_s(users)]
    {
      name: asana_name,
      notes: description,
      owner: users.first.try(:asana_id)
    }
  end

  private

  def relation_to_s(relation)
    relation.map(&:description).join(", ")
  end
end
