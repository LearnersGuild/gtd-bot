class IllegalRolesRenamer < BaseService
  takes :asana_client

  def perform(roles_from_glass_frog, roles_from_asana)
    gf_names = roles_from_glass_frog.map(&:name_with_prefix)
    gf_names += [ProjectObject::INDIVIDUAL_NAME]
    to_rename = roles_from_asana.reject { |r| gf_names.include?(r.name) }
    to_rename.each do |role|
      asana_client.update_project(role.asana_id, name: rename(role.name))
    end
  end

  private

  def rename(name)
    name.sub(/^#{RoleObject::NAME_PREFIX}/, ProjectObject::IGNORED_PREFIX)
  end
end
