class Role < ActiveRecord::Base
  serialize :accountabilities, JSON
  serialize :domains, JSON
  serialize :users, JSON
end
