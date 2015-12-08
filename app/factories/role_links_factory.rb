class RoleLinksFactory
  def from_db(links, klass)
    links.map { |attributes| klass.new(attributes) }
  end

  def from_glass_frog(links, klass)
    return [] if links.blank?

    links.map { |l| klass.new(description: l.description) }
  end
end
