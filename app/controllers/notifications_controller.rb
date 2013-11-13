class NotificationsController < ApplicationController
	before_filter :authenticate_user!
	after_filter :mark_as_read, only: :index  

	def index
		@user = current_user
		@notifications = @user.notifications.paginate(:page => params[:page])

		@title = 'My notifications'
		@page_class = 'notifications'
	end

	private
		def mark_as_read
			Notification.mark_all_as_read(current_user)
		end
end
