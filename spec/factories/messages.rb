FactoryGirl.define do
  factory :message do
    body { Faker::Lorem.paragraph(1) }
    sequence :from_user_id do |n|
      1 + n
    end
    sequence :to_user_id do |n|
      2 + n
    end

  end
end

# == Schema Information
#
# Table name: messages
#
#  body             :text
#  created_at       :datetime         not null
#  from_user_id     :integer
#  id               :integer          not null, primary key
#  read             :boolean          default(FALSE)
#  receiver_deleted :boolean          default(FALSE)
#  sender_deleted   :boolean          default(FALSE)
#  subject          :string(255)
#  to_user_id       :integer
#  updated_at       :datetime         not null
#
