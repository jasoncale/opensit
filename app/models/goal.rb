class Goal < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :goal_type

  attr_accessible :user_id, :duration, :goal_type, :date_started

  def to_s
  	text = "#{user.display_name} wants to sit for "
  	text << (self.fixed? ? "#{duration} days in a row" : "#{duration} minutes a day")
  	text << ". They started on #{date_started.strftime("%d %B %Y")}, and have met the goal on #{days_where_goal_met} out of #{days_into_goal} days, giving them a rating of #{rating}% (#{rating_colour})"
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
  	(date_started.to_date .. Date.today).count
  end

  # Returns the number of days (since the day the goal began) where the goal was met
  def days_where_goal_met
	  total = 0
  	if self.fixed?
	  	(date_started.to_date .. Date.today).each do |day|
	  		total += 1 if user.sat_on_date?(day)
	  	end
  		return total
	  else
	  	return 999
	  end
  end

  # How well is the user meeting the goal?
  def rating
  	if self.fixed?
  		rating = ((days_where_goal_met.to_f / days_into_goal.to_f) * 100).round
  	else
  		rating = "NA"
  	end
  end

  # Gold for 100%, Green for 80% and above, Amber for 50% and above, Red for anything below
  def rating_colour
  	case self.rating
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
#  date_ended   :datetime
#  date_started :datetime
#  duration     :integer
#  goal_type    :integer
#  id           :integer          not null, primary key
#  user_id      :integer
#
