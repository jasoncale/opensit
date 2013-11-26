class FavouritesController < ApplicationController
	before_filter :authenticate_user!
	
	def index
		@user = current_user
		@favs = @user.get_favourites(:delve => true)
		@latest = @user.latest_sits

		@title = 'My favourites'
		@page_class = 'favourites'
	end

	def create
		@user = current_user
		if !@user.favourited?(params[:favourite][:favourable_id])
	    @fav = @user.favourites.new(params[:favourite])
			@fav.save
			respond_to do |format|
				format.html { redirect_to favs_path }
	      format.js
	    end
		else
			render :status => 409
		end
	end

	def destroy
    @fav = Favourite.find(params[:id])
    @fav.destroy
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
	end

end
