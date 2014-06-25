class Goal < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :goal_type

  attr_accessible :user_id, :duration, :goal_type

  def fixed?
  	goal_type == 1
  end

  def ongoing?
  	goal_type == 0
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
