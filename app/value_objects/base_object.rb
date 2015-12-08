class BaseObject
  include Virtus.model

  IGNORED_PREFIX = '_'

  def update(attributes)
    self.attributes = attributes
  end

  def ==(other)
    attributes == other.attributes
  end

  def underscored?
    name_start_with?(IGNORED_PREFIX)
  end

  protected

  def name_start_with?(text)
    name.present? && name.start_with?(text)
  end
end
