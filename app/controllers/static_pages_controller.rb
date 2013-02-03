class StaticPagesController < ApplicationController
  def front
    @sits = Sit.newest_first.limit(10).all
  end
  
  def about
  end
end
