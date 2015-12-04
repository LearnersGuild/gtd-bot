require 'rails_helper'

describe TagsCollection do
  it_behaves_like "BaseCollection", TagsCollection, TagObject
end
