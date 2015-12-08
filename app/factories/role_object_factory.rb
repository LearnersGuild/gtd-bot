class RoleObjectFactory
  takes :role_links_factory, :user_object_factory

  def from_db(role)
    users = role.users.map { |u| user_object_factory.from_db(u) }
    RoleObject.new(
      glass_frog_id: role.glass_frog_id,
      name: role.name,
      asana_id: role.asana_id,
      asana_team_id: role.asana_team_id,
      purpose: role.purpose,
      accountabilities: role_links_factory.from_db(
        role.accountabilities, AccountabilityObject),
      domains: role_links_factory.from_db(
        role.domains, DomainObject),
      users: users
    )
  end

  def from_glass_frog(role)
    role_users = role.people || []
    users = role_users.map { |u| user_object_factory.from_glass_frog(u) }
    RoleObject.new(
      glass_frog_id: role.id,
      name: role.name,
      purpose: role.purpose,
      accountabilities: role_links_factory.from_glass_frog(
        role.accountabilities, AccountabilityObject),
      domains: role_links_factory.from_glass_frog(
        role.domains, DomainObject),
      users: users
    )
  end
end
