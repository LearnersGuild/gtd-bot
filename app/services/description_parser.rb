class DescriptionParser
  SPLIT_CHAR = ' '
  ASANA_SPACE_CODE = /\xC2\xA0/u
  PROJECT_MENTION = /^https:\/\/app.asana.com\/0\/(\d+)\/\d+$/

  def linked_ids(description)
    splitted, _ = split(description)
    splitted.map do |w|
      matched = w.match(PROJECT_MENTION)
      matched && matched[1]
    end.compact
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
