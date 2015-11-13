class BaseService
  extend Dependor::Injectable

  def injector
    @injector ||= ServicesInjector.new
  end
end
