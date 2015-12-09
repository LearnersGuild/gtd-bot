class ReportsInjector
  include Dependor::AutoInject

  def freshness_report
    Reports::FreshnessReport.new
  end
end
