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

	def previous_sit(sit)
		if sit.prev(current_user).nil?
			"<li class='previous'><div class=\"disabled\" title=\"This is the first entry\">&larr; Previous</div></li>".html_safe
		else
			"<li class='previous'><a href=\"#{sit_path(@sit.prev(current_user))}\">&larr; Previous</a></li>".html_safe
		end
	end

	def next_sit(sit)
		if sit.next(current_user).nil?
    	"<li class='next'><div class=\"disabled\" title=\"This is the latest entry\">Next &rarr;</div></li>".html_safe
    else
      "<li class='next'><a href=\"#{sit_path(@sit.next(current_user))}\">Next &rarr;</a></li>".html_safe
		end
	end

	def display_lock_if_private(sit)
		if sit.private
			'<div class="private-event pull-right" title="This is a private entry. Only you can see it."><i class="fa fa-lock"></i></div>'.html_safe
		end
	end
end
