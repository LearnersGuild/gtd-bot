module Strategies
  class BaseStrategy < BaseService
    def perform_with_logging
      logger.info("Perform started")
      perform
      logger.info("Perform finished")
    end
  end
end
