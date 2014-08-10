desc "Mass mail, with skip and limit to help with 200 a day limit"
task :mailshot => :environment do

  limit = ARGV.select{|a| a =~ /limit=/}.last
  skip = ARGV.select{|a| a =~ /skip=/}.last

  if limit
    limit = limit.split("=").last
  else
    limit = 200
  end

  if skip
    skip = skip.split("=").last
  else
    skip = 0
  end

  ActionMailer::Base.default_url_options = { :host => 'opensit.com' }

  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
  ActionMailer::Base.delivery_method = :smtp

  count = 0
  query = User.all.order(created_at: :asc).limit(limit).offset(skip)
  query.each do |user|
    UserMailer.goals_are_live(user).deliver
    count += 1
    puts "#{count} #{user.display_name} (#{user.email})"
  end
end