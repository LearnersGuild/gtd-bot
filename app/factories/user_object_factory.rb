class UserObjectFactory
  def from_asana(user)
    UserObject.new(
      asana_id: user.id,
      email: user.email
    )
  end

  def merge_users(glass_frog_users, asana_users)
    glass_frog_users.map do |glass_frog_user|
      asana_user = asana_users.detect { |u| u.matches?(glass_frog_user) }
      next unless asana_user

      build_merged(asana_user, glass_frog_user)
    end.compact
  end

  def build_merged(asana_user, glass_frog_user)
    UserObject.new(
      email: asana_user.email,
      asana_id: asana_user.asana_id,
      glass_frog_id: glass_frog_user.glass_frog_id
    )
  end
end
