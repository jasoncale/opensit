class UsersController < ApplicationController
  
  # GET /me page if logged in, /front if not
  def me
    if !user_signed_in?
      redirect_to front_path
    else
      @feed_items = current_user.socialstream.newest_first.paginate(:page => params[:page])
    end
  end

  # GET /my
  def my_sits
    @user = current_user
    @my_sits = @user.sits.newest_first.paginate(:page => params[:page])
  end

  # GET /users/1
  # View user page
  def show
    @user = User.find(params[:id])
    @sits = @user.sits.newest_first.paginate(:page => params[:page])
  end

  # GET /users/1/feed
  # Atom feed for a users sitstream
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

  # GET /user/:id/bio
  def bio
    @user = User.find(params[:id])
  end 

  # GET /user/:id/following
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users
    render 'show_follow'
  end

  # GET /user/:id/followers
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  # GET /user/:id/export
  def export
    @sits = Sit.where(:user_id => params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @sits }
      format.xml { render xml: @sits }
    end
  end
end
