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
end