module Reports
  class Runner < BaseService
    def self.perform
      new.perform
    end

    def perform
      logger.info("Generating reports")
      logger.info("Reports generated")
    end
  end
end
