FactoryGirl.define do
  factory :sit do
    user
    body "I done a meditate."
    s_type 0
    duration 30
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
