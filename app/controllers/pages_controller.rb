class PagesController < ApplicationController
  def front
    if current_user
      redirect_to me_path
    end

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
    @newest_users = User.newest_users
    @page_class = 'new-users'
  end

  def new_comments
    @comments = Comment.latest(5)
  end

  def active_users
  end

  def robots
    env = Rails.env.production? ? 'production' : 'other'
    robots = File.read("config/robots/robots.#{env}.txt")
    render :text => robots, :layout => false, :content_type => 'text/plain'
  end
end
