class ExceptionHandler
  def perform(exception)
    if Rails.env.development?
      fail exception
    else
      Honeybadger.notify(exception)
    end
  end
end
