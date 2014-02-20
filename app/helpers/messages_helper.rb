module MessagesHelper
	def unread_marker(msg)
		if !msg.read
			'<i class="fa fa-asterisk"></i>'.html_safe
		end
	end

	def inbox_unread_count(user)
		user.unread_count if user.unread_count
	end
end
