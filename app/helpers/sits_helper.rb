module SitsHelper
	def teaser(sit, length = 300, search = nil)
		stripped = strip_tags(sit.custom_strip)
		if search
			excerpt = excerpt(stripped, search, radius: 200)
			if !excerpt.blank?
				return highlight(excerpt, search)
			else
				return truncate(stripped, :length => length, :omission => " ...")
			end
		end
		return truncate(stripped, :length => length, :omission => " ...")
	end

	def teaser_title(sit, type = false)
		if sit.s_type == 0
      title = " sat for <a class='sit-link' title='#{sit.duration} minute meditation report by #{sit.user.display_name}' href='#{sit_path(sit)}'>#{sit.duration} minutes</a>".html_safe
		elsif sit.s_type == 1
			title = "added a <a class='sit-link' title='#{sit.title} by #{sit.user.display_name}' href='#{sit_path(sit)}'>diary</a>.".html_safe
		end
		return title
	end

	def display_lock_if_private(sit)
		if sit.private
			'<div class="private-event pull-right" title="This is a private entry. Only you can see it."><i class="fa fa-lock"></i></div>'.html_safe
		end
	end
end
