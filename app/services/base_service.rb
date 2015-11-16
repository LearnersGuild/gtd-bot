class BaseService
  extend Dependor::Injectable
  inject_from ServicesInjector

  def injector
    @injector ||= ServicesInjector.new
  end
end
