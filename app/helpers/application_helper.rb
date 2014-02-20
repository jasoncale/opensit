module ApplicationHelper
  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "OpenSit"
    if page_title.nil?
      "#{base_title} | Where Meditators Meet. Free Online Practice Journal"
    else
      "#{page_title} | #{base_title}"
    end
  end

	def tag_cloud(tags, classes)
	  max = tags.sort_by(&:count).last
	  tags.each do |tag|
	    index = tag.count.to_f / max.count.to_f * (classes.size - 1)
	    yield(tag, classes[index.round])
	  end
	end

  def tag_labels(tags)
    raw tags.map { |t| link_to t.name, tag_path(t.name), :class => 'label label-default tag-label' }.join
  end

  def new_notifications(user)
    if user.notifications.unread.count.zero?
      '<i class="fa fa-circle-o"></i>'.html_safe
    else
      count = '<i class="fa fa-circle"></i><span class="new-notifications">' + current_user.new_notifications.to_s + '</span>'
      count.html_safe
    end
  end

  def form_element(f, field, model, label, input_width,  options = {})
    form = "<div class='form-group'><label class='col-lg-2 control-label' for='#{model}_#{field}'>"
    form << label
    form << '</label>'
    form << "<div class=\"col-lg-#{input_width}\">"
    other = f.input field, options
    form << other
    form << '</div></div>'
    return form.html_safe
  end
end