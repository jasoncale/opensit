class Notification < ActiveRecord::Base
  attr_accessible :user_id, :message, :viewed, :link, :initiator, :object_type, :object_id

  belongs_to :user

  validates_presence_of :user_id, :message

  default_scope { order('created_at DESC') }
  scope :unread, -> { where(viewed: false) }

  self.per_page = 10

  # user_id = ID of the RECIPIENT
  def self.send_new_comment_notification(user_id, meta)

    username = meta[:commenter].display_name
    commenter_id = meta[:commenter].id
    sit_id = meta[:sit_id]
    comment_id = meta[:comment_id]
    sit_owner = meta[:sit_owner]
    if meta[:mine]
      message = "#{username} commented on your sit."
    else
      if sit_owner == username
        message = "#{username} also commented on their own sit."
      else
        message = "#{username} also commented on #{sit_owner}'s sit."
      end
    end
    # No need to notify the user if they've just commented on their own sit
    if commenter_id != user_id
      Notification.create(
        message: message,
        user_id: user_id,
        link: "/sits/#{sit_id}\#comment-#{comment_id}",
        initiator: commenter_id,
        object_type: 'comment',
        object_id: comment_id
      )
    end

  end

  # user_id = ID of the RECIPIENT
  def self.send_new_follower_notification(user_id, meta)

    user = meta[:follower]
    follower_id = meta[:follower].id
    follow_id = meta[:follow_id]

    Notification.create(
      message: "#{user.display_name} is now following you!",
      user_id: user_id,
      link: Rails.application.routes.url_helpers.user_path(meta[:follower]),
      initiator: follower_id,
      object_type: 'follow',
      object_id: follow_id
    )

  end

  def self.send_new_sit_like_notification(user_id, meta)

    username = meta[:liker].display_name
    liker_id = meta[:liker].id
    sit_id = meta[:sit_id]
    like_id = meta[:like_id]

    Notification.create(
      message: "#{username} likes your entry.",
      user_id: user_id,
      link: Rails.application.routes.url_helpers.sit_path(sit_id),
      initiator: liker_id,
      object_type: 'like',
      object_id: like_id
    )

  end

  def self.mark_all_as_read(current_user)
    @user = current_user
    @notifications = @user.notifications.unread
    @notifications.each do |n|
      n.viewed = true
      n.save
    end
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
