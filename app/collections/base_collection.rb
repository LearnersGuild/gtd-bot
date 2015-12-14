class BaseCollection < BaseService
  attr_accessor :items

  def initialize(items = [])
    self.items = items
  end

  delegate :include?, :each, :map, :detect, :to_a, :empty?, to: :items

  def add(item)
    @items.push(item)
    item
  end

  def delete(asana_id)
    items.delete_if { |item| item.asana_id == asana_id }
  end

  def ==(other)
    items == other.items
  end

  def select(&block)
    build_collection do
      items.select(&block)
    end
  end

  def reject(&block)
    build_collection do
      items.reject(&block)
    end
  end

  private

  def build_collection(&block)
    collection = block.call
    self.class.new(collection)
  end
end
