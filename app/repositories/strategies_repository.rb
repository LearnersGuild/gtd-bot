class StrategiesRepository
  def initialize
    @collection = {}
  end

  def register_performing(strategy, resource)
    @collection[strategy.class] ||= {}
    @collection[strategy.class][resource.class] ||= {}
    @collection[strategy.class][resource.class][resource.asana_id] = true
  end

  def already_performed?(strategy, resource)
    strategy_hash = @collection[strategy.class]
    return false unless strategy_hash

    type_hash = strategy_hash[resource.class]
    return false unless type_hash

    !type_hash[resource.asana_id].nil?
  end
end
