class Like < ActiveRecord::Base
  belongs_to :likeable
  belongs_to :user

  validates_presence_of :user_id, :likeable_id, :likeable_type
  attr_accessible :user_id, :likeable_type, :likeable_id

  after_save :create_notification

  def self.likers_for(obj)
    obj.likes.map { |u| User.find(u.user_id) }.reverse
  end

  private
    def create_notification
    	@obj = self.likeable_type.constantize.find(self.likeable_id)
      Notification.send_notification('NewLikeOnSit', @obj.user.id, { liker: self.user, sit_link: @obj.id })
    end
end
