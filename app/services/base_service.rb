require 'logger'

class BaseService
  extend Dependor::Injectable
  inject_from ServicesInjector

  def injector
    @injector ||= ServicesInjector.new
  end

  def logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = self.class
    end
  end
end
