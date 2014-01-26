FactoryGirl.define do
  factory :favourite do
    sequence :user_id do |n|
      n
    end
    sequence :favourable_id do |n|
      n
    end
    favourable_type "Sit"

  end
end
