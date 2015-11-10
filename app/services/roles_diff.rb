class RolesDiff
  attr_accessor :existing, :existing_ids, :roles_ids, :roles,
    :role_object_factory

  def initialize(roles, role_object_factory)
    self.roles = roles
    self.existing = Role.all.map { |r| role_object_factory.from_db(r) }
    self.existing_ids = existing.map(&:glass_frog_id)
    self.roles_ids = roles.map(&:glass_frog_id)
  end

  def perform
    { to_create: to_create, to_delete: to_delete, to_update: to_update }
  end

  private

  def to_create
    roles.select { |r| !existing_ids.include?(r.glass_frog_id) }
  end

  def to_delete
    existing.select { |r| !roles_ids.include?(r.glass_frog_id) }
  end

  def to_update
    existing_hash = Hash[existing.map { |r| [r.glass_frog_id, r] }]
    roles.select do |r|
      existing_hash[r.glass_frog_id] &&
        r.name != existing_hash[r.glass_frog_id].name
    end
  end
end
