require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

A9n.root = File.expand_path('../..', __FILE__)
A9n.load

module GtdBot
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
  end
end
