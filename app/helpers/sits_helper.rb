module SitsHelper
	def teaser_title(sit)
		if sit.s_type == 0
      " sat for #{link_to "#{sit.duration} minutes", sit, :class => 'sit-link'}".html_safe
		elsif sit.s_type == 1
			" added a new diary: #{link_to "#{sit.title}", sit, :class => 'sit-link'}".html_safe
		else
			" added a new article: #{link_to "#{sit.title}", sit, :class => 'sit-link'}".html_safe
		end
	end

	def previous_sit(sit)
		if current_page?(sit_path(sit.prev))
			'<span class="previous no-more" title="This is the first entry"><i class="icon-arrow-left"></i> Previous</span>'.html_safe
		else
			"<span class='previous'><i class='icon-arrow-left'></i> #{link_to 'Previous', sit_path(@sit.prev)} </span>".html_safe
		end
	end

	def next_sit(sit)
		if current_page?(sit_path(sit.next))
    	'<span class="next no-more" title="This is the latest entry">Next <i class="icon-arrow-right"></i></span>'.html_safe
    else
      "<span class='next'> #{link_to 'Next', sit_path(@sit.next)} <i class='icon-arrow-right'></i></span>".html_safe
		end
	end
end
