class Goal < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :goal_type

  attr_accessible :user_id, :duration, :goal_type

  # Fixed goal e.g. sit for 30 days in a row
  def fixed?
  	goal_type == 1
  end

  # Ongoing goal e.g. sit for 30 minutes a day
  def ongoing?
  	goal_type == 0
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

  def rating
  	if self.fixed?
  		rating = ((days_where_goal_met.to_f / days_into_goal.to_f) * 100).round(1)
  	else
  		rating = "NA"
  	end
  	puts "days into goal: #{days_into_goal}"
  	puts "days where goal met #{days_where_goal_met}"
  	puts "#{rating}%"
  end

  # Returns how many days into the goal the user is
  def days_into_goal
  	(date_started.to_date .. Date.today).count
  end
end

# == Schema Information
#
# Table name: goals
#
#  completed       :boolean          default(FALSE)
#  current_day     :integer
#  date_ended      :datetime
#  date_started    :datetime
#  duration        :integer
#  goal_type       :integer
#  id              :integer          not null, primary key
#  successful_days :integer          default(0)
#  user_id         :integer
#
