module ApplicationHelper
  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "OpenSit"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

	def tag_cloud(tags, classes)
	  max = tags.sort_by(&:count).last
	  tags.each do |tag|
	    index = tag.count.to_f / max.count * (classes.size - 1)
	    yield(tag, classes[index.round])
	  end
	end

  def tag_labels(tags)
    raw tags.map { |t| link_to t.name, tag_path(t.name), :class => 'label tag-label' }.join
  end
end
