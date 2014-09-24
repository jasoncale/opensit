require 'rubygems'
require 'json'
require 'net/http'

def fetch(url)
   resp = Net::HTTP.get_response(URI.parse(url))
   data = resp.body
   JSON.parse(data)
end

desc "Import JSON export into local database .."
task :import_sits, [:json_url, :username] => [:environment] do |t, args|

  user = User.where("lower(username) = lower(?)", args[:username]).first!

  if user
    if args[:json_url]
      data_hash = fetch(args[:json_url])
      data_hash.each do |entry|
        old_id = entry.delete('id')
        updated_at = entry.delete('updated_at')
        entry['user_id'] = user.id

        sit = Sit.new(entry)
        if !sit.save
          puts "couldn't save sit " + old_id
        end
      end
    else
      puts "pass json_url to the task"
    end
  else
    puts "user not found"
  end




end
