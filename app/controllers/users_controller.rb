class UsersController < ApplicationController
  
  # Me page (default)
  def me
    if !user_signed_in?
      redirect_to front_path
    else
      @sits = Sit.paginate(:page => params[:page]).order("created_at DESC").limit(10)
    end
  end

  def my_sits
    @user = current_user
    @my_sits = @user.sits.paginate(:page => params[:page]).order("created_at DESC").limit(10)
  end

  # GET /users/1
  # View user page
  def show
    @user = User.find(params[:id])
    @sits = @user.sits.paginate(:page => params[:page]).order("created_at DESC").limit(10)
  end

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
  # POST /users.json
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end
end
