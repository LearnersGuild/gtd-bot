class BaseObject
  include Virtus.model

  def update(attributes)
    self.attributes = attributes
  end

  def ==(other)
    attributes == other.attributes
  end
end
