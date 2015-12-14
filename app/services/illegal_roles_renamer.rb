class IllegalRolesRenamer < BaseService
  takes :projects_repository, :parallel_iterator

  def perform(exisiting_roles, roles_from_asana)
    exitising_ids = exisiting_roles.map(&:asana_id)
    to_rename = roles_from_asana.reject do |r|
      exitising_ids.include?(r.asana_id)
    end
    parallel_iterator.each(to_rename) do |role|
      logger.info("Updating illegal name for project #{role.name}...")
      projects_repository.update(role, name: rename(role.name))
      logger.info("Project updated")
    end
  end

  private

  def rename(name)
    name.sub(/^#{ProjectObject::ROLE_PREFIX}/, ProjectObject::IGNORED_PREFIX)
  end
end
