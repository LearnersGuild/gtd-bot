class RoleObjectFactory
  def from_db(role)
    accountabilities = role.accountabilities
      .map { |attributes| AccountabilityObject.new(attributes) }
    domains = role.domains
      .map { |attributes| DomainObject.new(attributes) }

    RoleObject.new(
      glass_frog_id: role.glass_frog_id,
      name: role.name,
      asana_id: role.asana_id,
      asana_team_id: role.asana_team_id,
      purpose: role.purpose,
      accountabilities: accountabilities,
      domains: domains
    )
  end

  def from_glass_frog(role)
    accountabilities = map_links(role.accountabilities, AccountabilityObject)
    domains = map_links(role.domains, DomainObject)
    RoleObject.new(
      glass_frog_id: role.id,
      name: role.name,
      purpose: role.purpose,
      accountabilities: accountabilities,
      domains: domains
    )
  end

  private

  def map_links(links, klass)
    return if links.blank?

    links.map { |l| klass.new(description: l.description) }
  end
end
