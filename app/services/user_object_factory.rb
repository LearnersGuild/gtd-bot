class UserObjectFactory
  def from_asana(user)
    UserObject.new(
      asana_id: user.id,
      email: user.email
    )
  end
end
