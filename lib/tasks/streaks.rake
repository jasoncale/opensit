desc "Streak checker"
task :streak_checker => :environment do
  User.all.each do |u|
    u.streak_breaker
  end
end
