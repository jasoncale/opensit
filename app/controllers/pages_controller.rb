class PagesController < ApplicationController
  def front
    @sits = Sit.newest_first.limit(5).all
    @newest_users = User.newest_users

    @page_class = 'front-page'
  end

  def explore
  	@sits = Sit.newest_first.limit(5).all
  	@newest_users = User.newest_users

    @title = 'Explore'
    @page_class = 'explore'
  end
  
  def about
    @title = 'About'
    @page_class = 'about'
  end
end
