class ExceptionHandler
  def context(data)
    Honeybadger.context(data)
  end

  def perform(exception)
    if Rails.env.development?
      fail exception
    else
      Honeybadger.notify(exception)
    end
  end
end
