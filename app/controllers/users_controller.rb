class UsersController < ApplicationController
  
  # Me page (default)
  def me
    if !user_signed_in?
      redirect_to front_path
    else
      @feed_items = current_user.socialstream.newest_first.paginate(:page => params[:page])
    end
  end

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

    # this will be our Feed's update timestamp
    @updated = @sits.last.updated_at unless @sits.empty?

    respond_to do |format|
      format.atom
    end
  end

  # GET /user/:id/bio
  def bio
    @user = User.find(params[:id])
  end 

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  # GET /users
  def index
    @users = User.all
  end
  
  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

  def export
    @sits = Sit.where(:user_id => params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @sits }
      format.xml { render xml: @sits }
    end
  end
end
