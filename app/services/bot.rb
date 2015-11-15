class Bot < BaseService
  takes :strategies, :exception_handler

  def perform
    strategies.each do |strategy|
      begin
        strategy.perform
      rescue StandardError => exception
        exception_handler.perform(exception)
      end
    end
  end
end

