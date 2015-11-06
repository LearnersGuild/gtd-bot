class Bot
  attr_accessor :strategies

  def initialize(strategies)
    self.strategies = strategies
  end

  def perform
    strategies.each(&:perform)
  end
end

