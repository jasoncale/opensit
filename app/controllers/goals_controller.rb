class GoalsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @goals = @user.goals

    @title = 'My goals'
    @page_class = 'goals'
  end

  def create
    @user = current_user
    @goal = @user.goals.new
    goal = params[:goal]
    if goal[:type] == 'ongoing'
      @goal.goal_type = 0
      @goal.mins_per_day = goal[:minutes]
    else
      @goal.goal_type = 1
      @goal.duration = goal[:duration]
      @goal.mins_per_day = goal[:mins_per_day] if goal[:mins_per_day]
    end

    if @goal.save
      redirect_to goals_path, notice: '"A journey of a thousand miles begins with a single sit" - You can do it!'
    else
      render action: "index"
    end
  end

  # PUT /goals/1
  def update
    @goal = Goal.find(params[:id])
    @goal.completed_date = Date.today

    if @goal.save!
      redirect_to goals_path, notice: 'Goal marked as finished'
    end
  end

  # DELETE /goals/1
  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy

    redirect_to goals_path, notice: 'Goal deleted'
  end
end