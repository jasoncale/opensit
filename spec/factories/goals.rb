FactoryGirl.define do
  factory :goal do
    association :user
    goal_type 0
    mins_per_day 1
    trait :sit_for_30_days do
      duration 30
      goal_type 1 # fixed
      created_at Date.today - 9
    end
    trait :sit_for_3_days do
      duration 3
      goal_type 1 # fixed
      created_at Date.today - 4
    end
    trait :sit_30_mins_a_day_for_30_days do
      duration 30
      mins_per_day 30
      goal_type 1 # fixed
      created_at Date.today - 4
    end
    trait :sit_for_30_minutes_a_day do
      mins_per_day 30
      goal_type 0 # ongoing
      created_at Date.today - 9
    end
  end
end

# == Schema Information
#
# Table name: goals
#
#  created_at    :datetime
#  duration      :integer
#  finished      :boolean          default(FALSE)
#  finished_date :datetime
#  goal_type     :integer
#  id            :integer          not null, primary key
#  mins_per_day  :integer
#  updated_at    :datetime
#  user_id       :integer
#
