class PagesController < ApplicationController
  def front
    @sits = Sit.public.newest_first.limit(10)
    @newest_users = User.newest_users
    @comments = Comment.latest(5)

    @page_class = 'front-page'
  end

  def about
    @title = 'About'
    @page_class = 'about'
  end

  def contact
    @title = 'Contact'
    @page_class = 'contact'
  end

  def robots
    env = Rails.env.production? ? 'production' : 'other'
    robots = File.read("config/robots/robots.#{env}.txt")
    render :text => robots, :layout => false, :content_type => 'text/plain'
  end
end
