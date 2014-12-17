class PagesController < ApplicationController
  def front
    if user_signed_in?
      redirect_to controller: :users, action: :me
    else
      @sits = Sit.communal.with_body.newest_first.limit(30)
      @page_class = 'front-page'

      render 'front', layout: 'minimal'
    end
  end

  def about
    @title = 'About'
    @page_class = 'about'
  end

  def contribute
    @title = 'Contribute to OpenSit'
    @page_class = 'contribute'
  end

  def contact
    @title = 'Contact'
    @page_class = 'contact'
  end

  def explore
    @user = current_user
    @sits = Sit.communal.newest_first.with_body.limit(20).paginate(:page => params[:page])

    @title = 'Explore'
    @page_class = 'explore'
  end

  def calendar
  end

  def tag_cloud
    @title = 'Popular Tags'
  end

  def new_users
    @users = User.newest_users(10).paginate(:page => params[:page])
    @page_class = 'new-users'
    @title = 'Newest Users'

    render 'users/user_results'
  end

  def online_users
  end

  def new_comments
    @comments = Comment.latest(10).paginate(:page => params[:page])
    @title = 'New comments'
  end

  def active_users
    @users = User.active_users.limit(10).paginate(:page => params[:page])
    @title = 'Active Users'
    render 'users/user_results'
  end

  def new_sitters
    @users = User.newest_users(10).where('sits_count > 0').paginate(:page => params[:page])
    @title = 'New Sitters'
    render 'users/user_results'
  end

  def robots
    env = Rails.env.production? ? 'production' : 'other'
    robots = File.read("config/robots/robots.#{env}.txt")
    render :text => robots, :layout => false, :content_type => 'text/plain'
  end
end
