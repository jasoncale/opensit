class Notification < ActiveRecord::Base
  attr_accessible :user_id, :message, :viewed, :link, :initiator

  belongs_to :user

  validates_presence_of :user_id, :message

  default_scope { order('created_at DESC') }
  scope :unread, -> { where(viewed: false) }

  def self.send_notification(notification_type, user_id, meta)

	  case notification_type
		  when 'NewComment'
		  	username = meta[:commenter].display_name
		  	commenter_id = meta[:commenter].id
		  	sit_id = meta[:sit_link]
		  	comment_id = meta[:comment_id]
		  	notify = Notification.create(
		  		message: "#{username} commented on your sit.", 
		  		user_id: user_id,
		  		link: "/sits/#{sit_id}\#comment-#{comment_id}",
		  		initiator: commenter_id
		  	)
		  end

		notify.save!
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
