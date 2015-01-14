class Notification < ActiveRecord::Base
  attr_accessible :user_id, :message, :viewed, :link, :initiator, :object_type, :object_id

  belongs_to :user

  validates_presence_of :user_id, :message

  default_scope { order('created_at DESC') }
  scope :unread, -> { where(viewed: false) }

  self.per_page = 10

  # user_id = ID of the RECIPIENT
  def self.send_new_comment_notification(user_id, comment, mine)

    username = comment.user.display_name
    sit_owner = comment.sit.user.display_name
    if mine
      message = "#{username} commented on your sit."
    else
      if sit_owner == username
        message = "#{username} also commented on their own sit."
      else
        message = "#{username} also commented on #{sit_owner}'s sit."
      end
    end

    # No need to notify the user if they've just commented on their own sit
    if comment.user.id != user_id
      Notification.create(
        message: message,
        user_id: user_id,
        link: "/sits/#{comment.sit.id}\#comment-#{comment.id}",
        initiator: comment.user.id,
        object_type: 'comment',
        object_id: comment.id
      )
    end

  end

  # user_id = ID of the RECIPIENT
  def self.send_new_follower_notification(user_id, follow)

    Notification.create(
      message: "#{follow.follower.display_name} is now following you!",
      user_id: user_id,
      link: Rails.application.routes.url_helpers.user_path(follow.follower),
      initiator: follow.follower.id,
      object_type: 'follow',
      object_id: follow.id
    )

  end

  def self.send_new_sit_like_notification(user_id, like)

    obj = Sit.find(like.likeable_id)
    last_notification = User.find(user_id).notifications.first

    # if last notification was a like of the same sit
    if can_combine_likes?(last_notification, like)

      like_count = Like.likers_for(obj).count
      if like_count == 2
        message = "#{like.user.display_name} and 1 other person liked your entry."
      else
        message = "#{like.user.display_name} and #{like_count - 1} other people liked your entry."
      end
      last_notification.update(
        message: message,
        initiator: like.user.id
      )

    else

      Notification.create(
        message: "#{like.user.display_name} likes your entry.",
        user_id: user_id,
        link: Rails.application.routes.url_helpers.sit_path(like.likeable_id),
        initiator: like.user.id,
        object_type: 'like',
        object_id: like.id
      )

    end


  end

  def self.mark_all_as_read(current_user)
    @user = current_user
    @notifications = @user.notifications.unread
    @notifications.each do |n|
      n.viewed = true
      n.save
    end
  end

  private

    def self.can_combine_likes?(last_notification, like)
      last_notification.present? and last_notification.object_id == like.likeable_id and last_notification.object_type == 'like'
    end
end

# == Schema Information
#
# Table name: notifications
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  initiator  :integer
#  link       :string(255)
#  message    :string(255)
#  updated_at :datetime
#  user_id    :integer
#  viewed     :boolean          default(FALSE)
#  object_type :string(255)
#  object_id  :integer
#
