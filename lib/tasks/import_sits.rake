require 'json'

desc "Import JSON export into local database .."
task :import_sits, [:json_file, :username] => [:environment] do |t, args|

  user = User.where("lower(username) = lower(?)", args[:username]).first!

  if user
    json_file = args[:json_file]

    if json_file && File.exists?(json_file)
      file = File.read(json_file)
      data_hash = JSON.parse(file)
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
      puts "pass path=export_json_file.json to the task"
    end
  else
    puts "user not found"
  end




end
