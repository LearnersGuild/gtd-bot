class RolesDiff
  attr_accessor :existing, :existing_ids, :roles_ids, :roles

  def initialize(roles)
    self.roles = roles
    self.existing = Role.all
    self.existing_ids = existing.map(&:glass_frog_id)
    self.roles_ids = roles.map(&:id)
  end

  def perform
    { to_create: to_create, to_delete: to_delete, to_update: to_update }
  end

  private

  def to_create
    roles.select { |r| !existing_ids.include?(r.id) }
  end

  def to_delete
    existing.select { |r| !roles_ids.include?(r.glass_frog_id) }
  end

  def to_update
    existing_hash = Hash[existing.map { |r| [r.glass_frog_id, r] }]
    roles.select do |r|
      existing_hash[r.id] && r.name != existing_hash[r.id].name
    end
  end
end
