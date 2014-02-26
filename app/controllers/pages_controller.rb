class PagesController < ApplicationController
  def front
    @sits = Sit.public.newest_first.limit(30)
    @page_class = 'front-page'

    render 'front', layout: 'minimal'
  end

  def about
    @title = 'About'
    @page_class = 'about'
  end

  def contact
    @title = 'Contact'
    @page_class = 'contact'
  end

  def explore
    @user = current_user
    @sits = Sit.public.newest_first.limit(20).paginate(:page => params[:page])

    @title = 'Explore'
    @page_class = 'explore'
  end

  def tag_cloud
  end

  def new_users
    @users = User.newest_users(10).paginate(:page => params[:page])
    @page_class = 'new-users'
    render 'users/user_results'
  end

  def new_comments
    @comments = Comment.latest(5)
  end

  def active_users
    @users = User.active_users.limit(10).paginate(:page => params[:page])
    render 'users/user_results'
  end

  def robots
    env = Rails.env.production? ? 'production' : 'other'
    robots = File.read("config/robots/robots.#{env}.txt")
    render :text => robots, :layout => false, :content_type => 'text/plain'
  end
end
