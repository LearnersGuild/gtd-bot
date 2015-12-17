class ExceptionHandler
  def context(data)
    Honeybadger.context(data)
  end

  def clear_context
    Honeybadger.context.clear!
  end

  def perform(exception)
    if Rails.env.development?
      fail exception
    else
      Honeybadger.notify(exception)
      clear_context
    end
  end
end
