class Bot
  attr_accessor :strategies

  def initialize(strategies)
    self.strategies = strategies
  end

  def perform
    strategies.each do |strategy|
      begin
        strategy.perform
      rescue => exception
        Honeybadger.notify(exception)
      end
    end
  end
end

