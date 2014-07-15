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
    if goal[:type] == 'mins'
      @goal.goal_type = goal[:days].blank? ? 0 : 1
      @goal.mins_per_day = goal[:duration]
      @goal.duration = goal[:days]
    else
      @goal.goal_type = 1
      @goal.duration = goal[:duration]
      @goal.mins_per_day = goal[:mins_per_day]
    end

    if @goal.save
      redirect_to goals_path, notice: '"A journey of a thousand miles begins with a single step" - Good luck, you can do it!'
    else
      render action: "index"
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end