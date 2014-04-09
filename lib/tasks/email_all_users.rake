desc "Email all users"
task :blog_is_live => :environment do
  User.all.each do |u|
    puts "Mailing #{u.email}"
    UserMailer.blog_is_live(u).deliver
    sleep 1
  end
end
