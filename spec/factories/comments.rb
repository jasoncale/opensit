FactoryGirl.define do
  factory :comment do
    user
    sit
    body "lol, yeah, you're enlightened now!!1"
  end
end

# == Schema Information
#
# Table name: comments
#
#  body       :text
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  sit_id     :integer
#  updated_at :datetime         not null
#  user_id    :integer
#
