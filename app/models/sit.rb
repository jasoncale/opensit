# == Schema Information
#
# Table name: sits
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  body           :text
#  user_id        :integer
#  allow_comments :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Sit < ActiveRecord::Base
  attr_accessible :disable_comments, :duration, :s_type, :body, :title, :user_id
  
  belongs_to :user
  has_many :comments
  
  validates :body, :presence => true
  validates :s_type, :presence => true

  # Pagination: sits per page
  self.per_page = 10

  def next
    user.sits.where("id > ?", id).first
  end

  def prev
    user.sits.where("id < ?", id).first
  end
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        # 
