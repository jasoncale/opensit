class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:my_sits]
  
  # GET /me page if logged in, /front if not
  def me
    if !user_signed_in?
      redirect_to front_path
    else
      @feed_items = current_user.socialstream.paginate(:page => params[:page])
      @user = current_user
    end

    @my_latest = @user.latest_sits
  end

  # GET /my
  def my_sits
    @user = current_user
    @links = @user.stream_range

    if params[:y] && params[:m]
      @my_sits = @user.sits_by_month(params[:y], params[:m]).newest_first
      @range_title = "#{Date::MONTHNAMES[params[:m].to_i]}, #{params[:y]}"
    elsif params[:y]
      @my_sits = @user.sits_by_year(params[:y]).newest_first
      @range_title = "All sits in #{params[:y]}"
    else
      @my_sits = @user.sits.newest_first.paginate(:page => params[:page])
    end
    
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @sits = @user.sits.newest_first.paginate(:page => params[:page])
  end

  # GET /users/1/feed
  # Atom feed for a users SitStream
  def feed
    @user = User.find(params[:id])
    @title = "SitStream for #{@user.username}"
    @sits = @user.sits.newest_first

    # This is the feed's update timestamp
    @updated = @sits.last.updated_at unless @sits.empty?

    respond_to do |format|
      format.atom
    end
  end

  # GET /user/1/profile
  def profile
    @user = User.find(params[:id])
  end 

  # GET /user/1/following
  def following
    @user = User.find(params[:id])
    @users = @user.followed_users
    @my_latest = @user.latest_sits

    if @user == current_user
      @my_favs = true
      @title = "People I follow"
    else
      @title = "People who #{@user.display_name} follows"
    end
    render 'show_follow'
  end

  # GET /user/1/followers
  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    @my_latest = current_user.sits.limit(5)

    if @user == current_user
      @my_favs = true
      @title = "People who follow me"
    else
      @title = "People who follow #{@user.display_name}"
    end
    render 'show_follow'
  end

  # GET /user/1/export
  def export
    @sits = Sit.where(:user_id => params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @sits }
      format.xml { render xml: @sits }
    end
  end
end
