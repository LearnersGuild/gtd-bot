class BaseObject
  include Virtus.model

  def ==(other)
    attributes == other.attributes
  end
end
