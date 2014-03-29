FactoryGirl.define do
  factory :sit do
    body "I done a meditate."
    s_type 0
    duration 30
    association :user

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

    trait :one_hour_ago do
      created_at { 1.hours.ago }
    end

    trait :two_hours_ago do
      created_at { 2.hours.ago }
    end

    trait :three_hours_ago do
      created_at { 3.hours.ago }
    end

    trait :one_year_ago do
      created_at { 1.years.ago }
    end

  end
end

# == Schema Information
#
# Table name: sits
#
#  body             :text
#  created_at       :datetime         not null
#  disable_comments :boolean
#  duration         :integer
#  id               :integer          not null, primary key
#  private          :boolean          default(FALSE)
#  s_type           :integer
#  title            :string(255)
#  updated_at       :datetime         not null
#  user_id          :integer
#  views            :integer          default(0)
#
