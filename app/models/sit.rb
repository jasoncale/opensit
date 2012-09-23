class Sit < ActiveRecord::Base
  validates :body, :presence => true
  has_many :comments
  
  attr_accessible :allow_comments, :body, :title, :user_id
end
