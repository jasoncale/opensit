class Notification < ActiveRecord::Base
  attr_accessible :user_id, :message, :viewed, :link, :initiator

  belongs_to :user

  validates_presence_of :user_id, :message

  default_scope { order('created_at DESC') }
  scope :unread, -> { where(viewed: false) }

  self.per_page = 10

  # user_id = ID of the RECIPIENT
  def self.send_notification(notification_type, user_id, meta)

    case notification_type
      when 'NewComment'
        username = meta[:commenter].display_name
        commenter_id = meta[:commenter].id
        sit_id = meta[:sit_link]
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
          notify = Notification.create(
            message: message,
            user_id: user_id,
            link: "/sits/#{sit_id}\#comment-#{comment_id}",
            initiator: commenter_id
          )
        end

      when 'NewFollower'
        username = meta[:follower].display_name
        follower_id = meta[:follower].id
        notify = Notification.create(
          message: "#{username} is now following you!",
          user_id: user_id,
          link: "#{username}",
          initiator: follower_id
        )
    end

    notify.save! if notify
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
#
