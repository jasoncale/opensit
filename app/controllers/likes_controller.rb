class LikesController < ApplicationController
	before_filter :authenticate_user!
	
	def create
		@user = current_user
		@obj = params[:like][:likeable_type].constantize.find(params[:like][:likeable_id])
		
		if !@user.likes?(@obj)
	    @likes = @user.likes.new(params[:like])
			@likes.save
			render 'toggle'
		else
			render :status => 409
		end
	end

	def destroy
    @user = current_user
    @obj = params[:like][:likeable_type].constantize.find(params[:like][:likeable_id])
    @user.unlike!(@obj)
		render 'toggle'
	end

end