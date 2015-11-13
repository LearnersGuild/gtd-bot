class DescriptionParser
  SPLIT_CHAR = ' '
  PROJECT_MENTION = /^https:\/\/app.asana.com\/0\/\d+\/\d+$/

  def plain_description(description)
    splitted, index = split(description)
    splitted[index..-1].join(SPLIT_CHAR)
  end

  def all_roles(description)
    splitted, _ = split(description)
    splitted.select { |w| w.match(PROJECT_MENTION) }
  end

  def prefix_roles(description)
    splitted, index = split(description)
    splitted[0...index]
  end

  private

  def split(description)
    splitted = description.split(SPLIT_CHAR)
    index = splitted.index { |w| !w.match(PROJECT_MENTION) }
    [splitted, index]
  end
end
