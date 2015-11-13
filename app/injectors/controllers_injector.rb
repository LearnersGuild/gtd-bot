class ControllersInjector
  include Dependor::AutoInject

  takes :params, :session, :request
end

