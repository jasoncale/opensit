module GoalsHelper
  def coloured_rating(goal)
    case goal.rating_colour
    when 'red'
      "<div class='rating rating-red'>#{goal.rating}%</div>".html_safe
    when 'amber'
      "<div class='rating rating-amber'>#{goal.rating}%</div>".html_safe
    when 'green'
      "<div class='rating rating-green'>#{goal.rating}%</div>".html_safe
    when 'gold'
      "<div class='rating rating-gold'>#{goal.rating}%</div>".html_safe
    end
  end

  def days_ago_in_words(from)
  	days = (Date.today - from.to_date).to_i
  	return 'today' if days == 0
  	return 'yesterday' if days == 1
  	return "#{days} days ago"
  end
end