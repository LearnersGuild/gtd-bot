class DescriptionParser
  SPLIT_CHAR = ' '
  ASANA_SPACE_CODE = /\xC2\xA0/u
  PROJECT_MENTION = /^https:\/\/app.asana.com\/0\/\d+\/\d+$/

  def plain_description(description)
    splitted, index = split(description)
    return '' unless index

    splitted[index..-1].join(SPLIT_CHAR)
  end

  def all_roles(description)
    splitted, _ = split(description)
    splitted.select { |w| w.match(PROJECT_MENTION) }
  end

  def prefix_roles(description)
    splitted, index = split(description)
    return splitted unless index

    splitted[0...index]
  end

  private

  def split(description)
    return [[], 0] if description.blank?

    description = description.gsub(ASANA_SPACE_CODE, SPLIT_CHAR)
    splitted = description.split(SPLIT_CHAR)
    index = splitted.index { |w| !w.match(PROJECT_MENTION) }
    [splitted, index]
  end
end
