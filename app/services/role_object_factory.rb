class RoleObjectFactory
  inject :role_links_factory

  def from_db(role)
    RoleObject.new(
      glass_frog_id: role.glass_frog_id,
      name: role.name,
      asana_id: role.asana_id,
      asana_team_id: role.asana_team_id,
      purpose: role.purpose,
      accountabilities: role_links_factory.from_db(
        role.accountabilities, AccountabilityObject),
      domains: role_links_factory.from_db(
        role.domains, DomainObject)
    )
  end

  def from_glass_frog(role)
    RoleObject.new(
      glass_frog_id: role.id,
      name: role.name,
      purpose: role.purpose,
      accountabilities: role_links_factory.from_glass_frog(
        role.accountabilities, AccountabilityObject),
      domains: role_links_factory.from_glass_frog(
        role.domains, DomainObject)
    )
  end
end
