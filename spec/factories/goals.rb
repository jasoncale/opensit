FactoryGirl.define do
  factory :goal do
    association :user
    goal_type 0
    trait :sit_for_30_days do
      duration 30
      goal_type 1 # fixed
      date_started Date.today - 9
    end
    trait :sit_for_30_minutes_a_day do
      duration 30
      goal_type 0 # ongoing
      date_started Date.today - 9
    end
  end
end

# == Schema Information
#
# Table name: goals
#
#  completed    :boolean          default(FALSE)
#  date_ended   :datetime
#  date_started :datetime
#  duration     :integer
#  goal_type    :integer
#  id           :integer          not null, primary key
#  user_id      :integer
#
