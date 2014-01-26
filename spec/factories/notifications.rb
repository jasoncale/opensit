FactoryGirl.define do
  factory :notification do
    message { Faker::Lorem.sentence(10) }
    sequence :user_id do |n|
      n
    end

  end
end
