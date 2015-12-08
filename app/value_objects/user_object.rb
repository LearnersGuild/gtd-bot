class UserObject < BaseObject
  attribute :asana_id, String
  attribute :email, String
  attribute :glass_frog_id, Integer

  def matches?(other)
    email == other.email
  end
end
