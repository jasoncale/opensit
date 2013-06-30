class StaticPagesController < ApplicationController
  def front
    @sits = Sit.newest_first.limit(10).all
  end

  def explore
  	@sits = Sit.newest_first.limit(5).all
  	@newest_users = User.newest_users
  end
  
  def about
  end
end
