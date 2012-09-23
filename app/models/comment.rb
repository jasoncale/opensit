class Comment < ActiveRecord::Base
  belongs_to :sit
  
  attr_accessible :body, :sit_id
end
