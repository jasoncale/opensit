desc "Email all users"
task :new_design_email => :environment do
  User.all.each do |u|
    puts "Mailing #{u.email}"
    UserMailer.new_design(u).deliver
    sleep 1
  end
end
