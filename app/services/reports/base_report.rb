module Reports
  class BaseReport < BaseService
    def injector
      @injector ||= ReportsInjector.new
    end

    def perform_with_logging
      logger.info("Perform started")
      perform
      logger.info("Perform finished")
    end
  end
end
