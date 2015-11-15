class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  extend Dependor::Injectable

  def injector
    @injector ||= ControllersInjector.new(params, session, request)
  end
end
