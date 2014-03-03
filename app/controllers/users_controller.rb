class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:export, :followers, :following]

  # GET /me page if logged in, /front if not
  def me
    if !user_signed_in?
      redirect_to front_path
    else
      @feed_items = current_user.socialstream.paginate(:page => params[:page])
      @user = current_user
      @latest = @user.latest_sits

      if @feed_items.empty?
        @users_to_follow = User.active_users.limit(5)
      end

      @title = 'Home'
      @page_class = 'me'
    end
  end

  # GET /u/buddha or /buddha
  def show
    @user = User.where("lower(username) = lower(?)", params[:username]).first!
    @links = @user.stream_range

    if !@user.private_stream
      if params[:y] && params[:m]
        if current_user == @user
          @sits = @user.sits_by_month(month: params[:m], year: params[:y]).newest_first
        else
          @sits = @user.sits_by_month(month: params[:m], year: params[:y]).public.newest_first
        end
        @range_title = "#{Date::MONTHNAMES[params[:m].to_i]}, #{params[:y]}"
      elsif params[:y]
        if current_user == @user
          @sits = @user.sits_by_year(params[:y]).newest_first
        else
          @sits = @user.sits_by_year(params[:y]).public.newest_first
        end
        @range_title = "All sits in #{params[:y]}"
      else
        if current_user && @user.id == current_user.id
          @sits = @user.sits.newest_first.paginate(:page => params[:page])
        else
          @sits = @user.sits.public.newest_first.paginate(:page => params[:page])
        end
      end
    end

    @title = "#{@user.display_name}\'s meditation practice journal"
    @desc = "#{@user.display_name} has logged #{@user.sits_count} meditation reports on OpenSit, a free community for meditators."
    @page_class = 'view-user'
  end

  # GET /u/buddha/following
  def following
    @user = User.where("lower(username) = lower(?)", params[:username]).first!
    @users = @user.followed_users
    @latest = @user.latest_sits

    if @user == current_user
      @title = "People I follow"
    else
      @title = "People who #{@user.display_name} follows"
    end

    @page_class = 'following'
    render 'show_follow'
  end

  # GET /u/buddha/followers
  def followers
    @user = User.where("lower(username) = lower(?)", params[:username]).first!
    @users = @user.followers
    @latest = @user.latest_sits

    if @user == current_user
      @title = "People who follow me"
    else
      @title = "People who follow #{@user.display_name}"
    end

    @page_class = 'followers'
    render 'show_follow'
  end

  # Generate atom feed for user or all public content (global)
  def feed
    if params[:scope] == 'global'
      @sits = Sit.public.newest_first.limit(50)
      @title = "Global SitStream - opensit.com"
    else
      @user = User.where("lower(username) = lower(?)", params[:username]).first!
      @title = "SitStream for #{@user.username}"
      @sits = @user.sits.public.newest_first.limit(20)
    end

    # This is the feed's update timestamp
    @updated = @sits.last.updated_at unless @sits.empty?

    respond_to do |format|
      format.atom
    end
  end

  # GET /u/buddha/export
  def export
    @user = User.where("lower(username) = lower(?)", params[:username]).first!
    @sits = Sit.where(:user_id => @user.id)

    respond_to do |format|
      format.html
      format.json { render json: @sits }
      format.xml { render xml: @sits }
    end
  end

end
