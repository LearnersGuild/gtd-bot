module Reports
  class Factory < BaseReport
    def create
      [injector.freshness_report]
    end
  end
end
