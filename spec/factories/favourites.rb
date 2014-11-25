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

# == Schema Information
#
# Table name: favourites
#
#  created_at      :datetime
#  favourable_id   :integer
#  favourable_type :string(255)
#  id              :integer          not null, primary key
#  updated_at      :datetime
#  user_id         :integer
#
# Indexes
#
#  index_favourites_on_favourable_id  (favourable_id)
#  index_favourites_on_user_id        (user_id)
#
