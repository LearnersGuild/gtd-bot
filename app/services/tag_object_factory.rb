class TagObjectFactory
  def build_from_asana(tag)
    TagObject.new(asana_id: tag.id, name: tag.name)
  end
end
