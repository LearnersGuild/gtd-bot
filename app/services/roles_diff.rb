class RolesDiff
  attr_accessor :existing, :existing_ids, :glass_frog_roles_ids,
    :glass_frog_roles

  def initialize(glass_frog_roles, existing_roles, role_object_factory)
    self.glass_frog_roles = glass_frog_roles
    self.existing = existing_roles.map { |r| role_object_factory.from_db(r) }
    self.existing_ids = existing.map(&:glass_frog_id)
    self.glass_frog_roles_ids = glass_frog_roles.map(&:glass_frog_id)
  end

  def perform
    { to_create: to_create, to_delete: to_delete, to_update: to_update }
  end

  private

  def to_create
    glass_frog_roles.select { |r| !existing_ids.include?(r.glass_frog_id) }
  end

  def to_delete
    existing.select { |r| !glass_frog_roles_ids.include?(r.glass_frog_id) }
  end

  def to_update
    existing_hash = Hash[existing.map { |r| [r.glass_frog_id, r] }]
    selected = select_to_update(existing_hash)
    map_to_update(selected, existing_hash)
  end

  def select_to_update(existing_hash)
    glass_frog_roles.select do |r|
      existing_hash[r.glass_frog_id] &&
        r != existing_hash[r.glass_frog_id]
    end
  end

  def map_to_update(roles, existing_hash)
    roles.map do |r|
      existing = existing_hash[r.glass_frog_id]
      merged_attributes = r.attributes.merge(
        asana_id: existing.asana_id,
        asana_team_id: existing.asana_team_id
      )
      RoleObject.new(merged_attributes)
    end
  end
end
