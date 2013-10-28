class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :configure_permitted_parameters, if: :devise_controller?

	def custom_user_auth
    unless user_signed_in?
    	redirect_to('/users/sign_in')
    end
	end

  protected

	  def configure_permitted_parameters
	    devise_parameter_sanitizer.for(:sign_up) do |u| 
	    	u.permit(:username, :email, :password, :password_confirmation)
	  	end

	  	devise_parameter_sanitizer.for(:account_update) do |u|
	  		u.permit('first_name', 'last_name', 'dob(3i)', 'dob(2i)', 'dob(1i)', 'gender', 'city', 'country', 'website', 'who', 'style', 'why', 'practice', 'default_sit_length')
	  	end
	  end
end
