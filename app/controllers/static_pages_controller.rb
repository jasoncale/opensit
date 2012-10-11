class StaticPagesController < ApplicationController
  def home
    # 5 most recent sits for the Global SitStream
    @sits = Sit.order("created_at DESC").limit(10).all
  end

  def help
  end
  
  def about
  end
end
