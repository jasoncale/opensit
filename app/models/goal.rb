class Goal < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :goal_type
  validates_presence_of :duration, :if => "goal_type == 'fixed'"
  attr_accessible :user_id, :duration, :goal_type

  def to_s
  	text = "#{user.display_name} wants to sit for "
  	if ongoing?
  		text << "#{mins_per_day} minutes a day"
  	else
	  	if fixed
	  		if mins_per_day
	  			text << "#{mins_per_day} minutes a day, for #{duration}"
	  		else
	  			text << "#{duration} days in a row"
	  		end
	  	end
	  end
  	text << ". They started on #{created_at.strftime("%d %B %Y")}, and have met the goal on #{days_where_goal_met} out of #{days_into_goal} days, giving them a rating of #{rating}% (#{rating_colour})"
  end

  # Fixed goal e.g. sit for 30 days in a row
  def fixed?
  	goal_type == 1
  end

  # Ongoing goal e.g. sit for 30 minutes a day
  def ongoing?
  	goal_type == 0
  end

  # Returns how many days into the goal the user is
  def days_into_goal
  	(created_at.to_date .. Date.today).count
  end

  # Returns the number of days (since the day the goal began) where the goal was met
  def days_where_goal_met
  	# Rate based on last 2 weeks of results, or since started (if less than two weeks into goal)
  	start_from = days_into_goal < 14 ? created_at.to_date : Date.today - 14
	  total = 0
  	if fixed?
  		return user.days_sat_for_min_x_minutes_in_date_range(mins_per_day, start_from, Date.today) if mins_per_day
  		return user.days_sat_in_date_range(created_at.to_date, Date.today)
	  else
	  	return user.days_sat_for_min_x_minutes_in_date_range(mins_per_day, start_from, Date.today)
	  end
  end

  # How well is the user meeting the goal?
  def rating
  	if fixed?
  		((days_where_goal_met.to_f / days_into_goal.to_f) * 100).round
  	else
  		# Rate based on last 2 weeks of results, or since started (if less than two weeks into goal)
	  	last_2_weeks = days_into_goal < 14 ? days_into_goal : 14
  		((days_where_goal_met.to_f / last_2_weeks.to_f) * 100).round
  	end
  end

  # Gold for 100%, Green for 80% and above, Amber for 50% and above, Red for anything below
  def rating_colour
  	case rating
		when 0..49
		  "red"
		when 50..79
		  "amber"
		when 80..99
		  "green"
		when 100
		  "gold"
		end
	end
end

# == Schema Information
#
# Table name: goals
#
#  completed    :boolean          default(FALSE)
#  created_at   :datetime
#  date_ended   :datetime
#  duration     :integer
#  goal_type    :integer
#  id           :integer          not null, primary key
#  mins_per_day :integer
#  updated_at   :datetime
#  user_id      :integer
#
