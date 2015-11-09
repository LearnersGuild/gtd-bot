class RoleObject
  include Virtus.model

  attribute :glass_frog_id, Integer
  attribute :name, String

  def self.from_db(role)
    new(glass_frog_id: role.glass_frog_id, name: role.name)
  end

  def self.from_glass_frog(role)
    new(glass_frog_id: role.id, name: role.name)
  end

  def ==(other)
    attributes == other.attributes
  end
end
