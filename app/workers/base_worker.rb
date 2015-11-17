class BaseWorker
  extend Dependor::Injectable
  inject_from WorkersInjector

  def injector
    @injector ||= WorkersInjector.new
  end
end
