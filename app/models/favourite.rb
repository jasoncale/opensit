class Favourite < ActiveRecord::Base
  belongs_to :favourable
  belongs_to :user

  validates_presence_of :user_id, :favourable_id, :favourable_type
  attr_accessible :user_id, :favourable_type, :favourable_id
end
