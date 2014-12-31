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
      Notification.send_new_sit_like_notification(@obj.user.id, self)
    end
end

# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_id   :integer
#  likeable_type :string(255)
#  user_id       :integer
#
# Indexes
#
#  index_likes_on_likeable_id  (likeable_id)
#  index_likes_on_user_id      (user_id)
#
