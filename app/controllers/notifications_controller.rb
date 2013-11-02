class NotificationsController < ApplicationController
	before_filter :authenticate_user!
	
	def index
		@user = current_user
		@notifications = @user.notifications

		@title = 'My notifications'
		@page_class = 'notifications'
	end
	
end
