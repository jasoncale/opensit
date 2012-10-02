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
  attr_accessible :allow_comments, :body, :title, :user_id
  
  belongs_to :user
  has_many :comments
  
  validates :body, :presence => true
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        # 
