FactoryGirl.define do
  factory :user do
    username "buddha"
    email { "#{username.downcase}@example.com" }
    password "gunsbitchesbling"
  end
end