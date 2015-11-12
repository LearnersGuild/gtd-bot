class ProjectObject
  include Virtus.model

  attribute :asana_id, String
  attribute :name, String
  attribute :owner_id, String
  attribute :tasks, Array
end
