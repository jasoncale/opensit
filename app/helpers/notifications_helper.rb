module NotificationsHelper
	def viewed_or_not(notification)
		if !notification.viewed
			'new-notification'
		end
	end
end
