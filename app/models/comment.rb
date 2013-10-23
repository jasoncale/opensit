# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  sit_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :sit
  
  attr_accessible :body, :sit_id, :user_id

  validates :body, :presence => true

  scope :newest_first, order("created_at DESC")

  def self.latest(count = 5)
    self.newest_first.limit(count)
  end
end
