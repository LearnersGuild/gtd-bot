class Role < ActiveRecord::Base
  serialize :accountabilities, JSON
  serialize :domains, JSON
end
