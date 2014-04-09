class UserMailer < ActionMailer::Base
  default from: "hello@opensit.com"

  def new_design(user)
    @email = user.email
    @name = user.display_name

    mail(to: @email, subject: "Psst.. OpenSit has changed!")
	end

	def welcome_email(user)
		@email = user.email
		mail(to: @email, subject: 'Welcome to the community!') if user.email
	end

	def blog_is_live(user)
		@email = user.email
		mail(to: @email, subject: 'The OpenSit Blog is Live!') if user.email
	end
end