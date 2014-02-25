class UserMailer < ActionMailer::Base
  default from: "hello@opensit.com"

  def new_design(user)
    @email = user.email
    @name = user.display_name

    mail(to: @email, subject: "Psst.. OpenSit has changed!")
	end
end