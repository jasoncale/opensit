module GoalsHelper
  def coloured_rating(goal)
    case goal.rating_colour
    when 'red'
      "<span class='label label-danger'>#{goal.rating}%</span>".html_safe
    when 'amber'
      "<span class='label label-warning'>#{goal.rating}%</span>".html_safe
    when 'green'
      "<span class='label label-success'>#{goal.rating}%</span>".html_safe
    when 'gold'
      "<span class='label label-warning'>#{goal.rating}%</span>".html_safe
    end
  end

  def days_ago_in_words(from)
  	days = (Date.today - from.to_date).to_i
  	return 'today' if days == 0
  	return 'yesterday' if days == 1
  	return "#{days} days ago"
  end
end