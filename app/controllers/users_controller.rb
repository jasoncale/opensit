class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:my_sits, :export, :following, :followers]

  # GET /me page if logged in, /front if not
  def me
    if !user_signed_in?
      redirect_to front_path
    else
      @feed_items = current_user.socialstream.paginate(:page => params[:page])
      @user = current_user
      @latest = @user.latest_sits(current_user)

      @title = 'Home'
      @page_class = 'me'
    end
  end

  # GET /u/buddha or /buddha
  def show
    begin
      @user = User.where("lower(username) = lower(?)", params[:username]).first!
    rescue ActiveRecord::RecordNotFound
      # Ideally the below would just call 'not_found' but this leads to db timeouts (pool gets filled with stale)
      render 'public/404', status: 404, layout: false
      return false
    end
    @links = @user.stream_range

    if params[:y] && params[:m]
      @sits = @user.sits_by_month(params[:y], params[:m]).newest_first
      @range_title = "#{Date::MONTHNAMES[params[:m].to_i]}, #{params[:y]}"
    elsif params[:y]
      @sits = @user.sits_by_year(params[:y]).newest_first
      @range_title = "All sits in #{params[:y]}"
    else
      if current_user && @user.id == current_user.id
        @sits = @user.sits.newest_first.paginate(:page => params[:page])
      else
        @sits = @user.sits.public.newest_first.paginate(:page => params[:page])
      end
    end

    @title = "#{@user.display_name}\'s practice log"
    @page_class = 'view-user'
  end

  # GET /u/buddha/profile
  def profile
    begin
      @user = User.where("lower(username) = lower(?)", params[:username]).first!
    rescue ActiveRecord::RecordNotFound
      # Ideally the below would just call 'not_found' but this leads to db timeouts (pool gets filled with stale)
      render 'public/404', status: 404, layout: false
      return false
    end
    @links = @user.stream_range

    @title = @user.display_name
    @page_class = 'view-profile'
  end

  # GET /u/buddha/following
  def following
    begin
      @user = User.where("lower(username) = lower(?)", params[:username]).first!
    rescue ActiveRecord::RecordNotFound
      # Ideally the below would just call 'not_found' but this leads to db timeouts (pool gets filled with stale)
      render 'public/404', status: 404, layout: false
      return false
    end
    @users = @user.followed_users
    @latest = @user.latest_sits(current_user)

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
    begin
      @user = User.where("lower(username) = lower(?)", params[:username]).first!
    rescue ActiveRecord::RecordNotFound
      # Ideally the below would just call 'not_found' but this leads to db timeouts (pool gets filled with stale)
      render 'public/404', status: 404, layout: false
      return false
    end
    @users = @user.followers
    @latest = @user.latest_sits(current_user)

    if @user == current_user
      @title = "People who follow me"
    else
      @title = "People who follow #{@user.display_name}"
    end

    @page_class = 'followers'
    render 'show_follow'
  end

  def explore
    @user = current_user
    @latest = @user.latest_sits(current_user)
    @sits = Sit.public.newest_first.limit(10)
    @newest_users = User.newest_users
    @comments = Comment.latest(5)

    @title = 'Explore'
    @page_class = 'explore'
  end

  # Generate atom feed for user or all public content (global)
  def feed
    if params[:scope] == 'global'
      @sits = Sit.public.newest_first.limit(50)
      @title = "Global SitStream - opensit.com"
    else
      begin
        @user = User.where("lower(username) = lower(?)", params[:username]).first!
      rescue ActiveRecord::RecordNotFound
        # Ideally the below would just call 'not_found' but this leads to db timeouts (pool gets filled with stale)
        render 'public/404', status: 404, layout: false
        return false        
      end
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
    begin
      @user = User.where("lower(username) = lower(?)", params[:username]).first!
    rescue ActiveRecord::RecordNotFound
      # Ideally the below would just call 'not_found' but this leads to db timeouts (pool gets filled with stale)
      render 'public/404', status: 404, layout: false
      return false
    end
    @sits = Sit.where(:user_id => @user.id)

    respond_to do |format|
      format.html
      format.json { render json: @sits }
      format.xml { render xml: @sits }
    end
  end

end
