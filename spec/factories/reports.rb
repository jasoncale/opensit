FactoryGirl.define do
  factory :report do
    reason { Faker::Lorem.characters(20) }
    body { Faker::Lorem.characters(50) }
  end

end

# == Schema Information
#
# Table name: reports
#
#  id              :integer          not null, primary key
#  reportable_id   :integer
#  reportable_type :string(255)
#  user_id         :integer
#  reason          :string(255)
#  body            :text
#  created_at      :datetime
#  updated_at      :datetime
#
