FactoryGirl.define do
  factory :user do
    username "buddha"
    email { "#{username.downcase}@example.com" }
    password "gunsbitchesbling"
  end

  factory :sit do
    user
    body "I done a meditate."
    s_type 0
    duration 30
  end

  factory :comment do
    user
    sit
    body "lol, yeah, you're enlightened now!!1"
  end
end