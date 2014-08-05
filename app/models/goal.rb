class Goal < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :goal_type
  validates_presence_of :duration, :if => "goal_type == 1"
  validates_presence_of :mins_per_day, :if => "goal_type == 0"
  attr_accessible :user_id, :duration, :goal_type, :mins_per_day

  def verbalise
    text = 'Sit for '
  	if ongoing?
  		text << "#{mins_per_day} minutes a day"
  	else
	  	if fixed?
	  		if mins_per_day
	  			text << "#{mins_per_day} minutes a day, for #{duration} days"
	  		else
	  			text << "#{duration} days in a row"
	  		end
	  	end
	  end
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
    end_date = completed_date ? completed_date : Date.today
  	(created_at.to_date .. end_date).count
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

	def goal_end_date
		created_at + duration.days
	end

	def completed?
    return true if completed_date # completed_date is used to retire (not delete) a goal
    return true if fixed? && (Date.today > goal_end_date) # Fixed goal are auto-marked as complete (not deleted) when past their finish date
		return false
  end

end

# == Schema Information
#
# Table name: goals
#
#  completed_date :datetime
#  created_at     :datetime
#  duration       :integer
#  goal_type      :integer
#  id             :integer          not null, primary key
#  mins_per_day   :integer
#  updated_at     :datetime
#  user_id        :integer
#
