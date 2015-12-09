module Reports
  class Runner < BaseReport
    takes :reports

    def self.perform
      reports_factory = Reports::Factory.new
      reports = reports_factory.create
      new(reports).perform
    end

    def perform
      logger.info("Generating reports")
      reports.each(&:perform_with_logging)
      logger.info("Reports generated")
    end
  end
end
