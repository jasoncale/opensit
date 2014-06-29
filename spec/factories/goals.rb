FactoryGirl.define do
  factory :goal do
    association :user
    goal_type 0
    trait :sit_for_30_days do
      duration 30
      goal_type 1 # fixed
      date_started Date.today - 9
    end
  end
end