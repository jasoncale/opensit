class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favourable, polymorphic: true

  validates_presence_of :user_id, :favourable_id, :favourable_type
  attr_accessible :user_id, :favourable_type, :favourable_id
end

# == Schema Information
#
# Table name: favourites
#
#  created_at      :datetime         not null
#  favourable_id   :integer
#  favourable_type :string(255)
#  id              :integer          not null, primary key
#  updated_at      :datetime         not null
#  user_id         :integer
#
# Indexes
#
#  index_favourites_on_favourable_id  (favourable_id)
#  index_favourites_on_user_id        (user_id)
#
