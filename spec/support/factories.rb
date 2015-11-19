FactoryGirl.define do
  factory :role do
    sequence(:glass_frog_id) { |n| n }
    sequence(:name) { |n| "Role#{n}" }
    sequence(:asana_id) { |n| "AsanaId#{n}" }
    sequence(:asana_team_id) { |n| "AsanaTeamId#{n}" }
  end
end

