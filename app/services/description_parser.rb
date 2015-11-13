class DescriptionParser
  SPLIT_CHAR = ' '

  def plain_description(description)
    select_from(description) { |w| !w.start_with?(RoleObject::NAME_PREFIX) }
      .join(SPLIT_CHAR)
  end

  def roles(description)
    select_from(description) { |w| w.start_with?(RoleObject::NAME_PREFIX) }
  end

  private

  def select_from(description, &block)
    description.split(SPLIT_CHAR).select(&block)
  end
end
