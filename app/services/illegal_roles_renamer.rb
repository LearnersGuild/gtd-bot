class IllegalRolesRenamer < BaseService
  takes :asana_client

  def perform(roles_from_glass_frog, roles_from_asana)
    gf_names = roles_from_glass_frog.map(&:name_with_prefix)
    gf_names += [ProjectObject::INDIVIDUAL_ROLE]
    to_rename = roles_from_asana.reject { |r| gf_names.include?(r.name) }
    to_rename.each do |role|
      logger.info("Updating illegal name for project #{role.name}...")
      asana_client.update_project(role.asana_id, name: rename(role.name))
      logger.info("Project updated")
    end
  end

  private

  def rename(name)
    name.sub(/^#{ProjectObject::ROLE_PREFIX}/, ProjectObject::IGNORED_PREFIX)
  end
end
