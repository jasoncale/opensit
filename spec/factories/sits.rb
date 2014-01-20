FactoryGirl.define do
  factory :sit do
    body "I done a meditate."
    s_type 0
    duration 30

    trait :journal do
      s_type 1
      title "Making factories"
      duration nil
    end

    trait :belongs_to_user do
      association :user, factory: :user
    end

    trait :private do
      private true
    end

    trait :public do
      private false
    end

    trait :one_day_ago do
      created_at { 1.days.ago }
    end

    trait :two_days_ago do
      created_at { 2.days.ago }
    end

    trait :three_days_ago do
      created_at { 3.days.ago }
    end

    trait :four_days_ago do
      created_at { 4.days.ago }
    end
  end
end

# == Schema Information
#
# Table name: sits
#
#  body             :text
#  created_at       :datetime
#  disable_comments :boolean
#  duration         :integer
#  id               :integer          not null, primary key
#  private          :boolean          default(FALSE)
#  s_type           :integer
#  title            :string(255)
#  updated_at       :datetime
#  user_id          :integer
#  views            :integer          default(0)
#
