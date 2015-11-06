FactoryGirl.define do
  factory :role do
    sequence(:glass_frog_id) { |n| n }
    sequence(:name) { |n| "Role#{n}" }
  end
end

