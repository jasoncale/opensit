FactoryGirl.define do
  factory :user do
    sequence :username do |n|
      "#{Faker::Name.first_name}#{n}"
    end
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(12) }

    factory :buddha do
      username "buddha"
    end

    factory :ananda do
      username "ananda"
    end

    trait :has_first_name do
      first_name { Faker::Name.first_name }
    end

    trait :no_first_name do
      first_name nil
    end

    trait :has_last_name do
      last_name { Faker::Name.last_name }
    end

    trait :no_last_name do
      last_name nil
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  authentication_token   :string(255)
#  authorised_users       :string(255)      default("")
#  avatar_content_type    :string(255)
#  avatar_file_name       :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  city                   :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  country                :string(255)
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  default_sit_length     :integer          default(30)
#  dob                    :date
#  email                  :string(255)
#  encrypted_password     :string(128)      default(""), not null
#  failed_attempts        :integer          default(0)
#  first_name             :string(255)
#  gender                 :integer
#  id                     :integer          not null, primary key
#  last_name              :string(255)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  password_salt          :string(255)
#  practice               :text
#  privacy_setting        :string(255)      default("public")
#  remember_created_at    :datetime
#  remember_token         :string(255)
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  sits_count             :integer          default(0)
#  streak                 :integer          default(0)
#  style                  :string(100)
#  unlock_token           :string(255)
#  updated_at             :datetime         not null
#  user_type              :integer
#  username               :string(255)
#  website                :string(100)
#  who                    :text
#  why                    :text
#
