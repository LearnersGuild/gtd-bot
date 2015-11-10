class RoleObject
  include Virtus.model

  attribute :glass_frog_id, Integer
  attribute :name, String
  attribute :asana_id, String

  def ==(other)
    attributes == other.attributes
  end
end
