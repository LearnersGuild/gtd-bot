source 'https://rubygems.org'
gem 'rails', '4.2.4'

gem 'pg'
gem 'a9n'
gem 'honeybadger', '~> 2.0'
gem 'sidekiq'
gem 'glassfrog'
gem 'asana'
gem 'virtus'
gem 'dependor'

group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
end

group :development do
  gem 'rubocop', git: 'git@github.com:bbatsov/rubocop.git'

  gem 'web-console', '~> 2.0'

  gem 'capistrano', '~> 3.3'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
end

group :test do
  gem 'factory_girl'
  gem 'simplecov'
end

group :production do
  gem 'unicorn'
end
