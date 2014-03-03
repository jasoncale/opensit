class SessionsController < Devise::SessionsController
  def new
    @title = 'Sign in'
    super
  end
end