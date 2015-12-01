source 'https://rubygems.org'
gem 'rails', '4.2.4'

gem 'pg'
gem 'a9n'
gem 'honeybadger', '~> 2.0'
gem 'glassfrog', git: 'git@github.com:LunarLogic/glassfrog-ruby.git'
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
  gem 'awesome_print'
end

group :development do
  gem 'rubocop', git: 'git@github.com:bbatsov/rubocop.git'

  gem 'web-console', '~> 2.0'

  gem 'capistrano', '~> 3.3'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'

  gem 'god'
end

group :test do
  gem 'factory_girl'
  gem 'simplecov'
end

group :production do
  gem 'unicorn'
end

group :profile do
  gem 'ruby-prof'
end
