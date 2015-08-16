class UserMailer < ActionMailer::Base
  default from: "\"Alan from Fountainhead School\" <hello@fountainheadschool.org>"

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

  def goals_are_live(user)
    @email = user.email
    mail(to: @email, subject: 'Set goals for your meditation') if user.email
  end

  # 11th Jan 2015
  def calendar_intro_email(user)
    @email = user.email
    mail(to: @email, subject: 'Meditate with people from around the globe!') if user.email
  end
end
