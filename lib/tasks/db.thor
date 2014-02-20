class Db < Thor
  include Thor::Actions

  no_tasks do
    def database
      env = ENV['RAILS_ENV'] || 'development'
      YAML.load_file('config/database.yml')[env]['database']
    end

    def run_sql(sql)
      say_status :sql, sql
      `echo "#{sql}" |  psql -d #{database}`
    end

    def cpu_cores
      Integer(`sysctl -n hw.ncpu`) rescue 3
    end

    def dump_file
      '/tmp/latest_opensit.dump'
    end
  end

  desc "capture", "capture production snapshot"
  def capture
    puts "Capturing production database..."
    run('heroku pgbackups:capture --expire --app opensit')
  end

  desc "pull", "pull production snapshot"
  def pull
    puts "Downloading production snapshot..."
    get `heroku pgbackups:url --app opensit`.gsub("\"", "").strip, dump_file, force: true
  end

  desc "migrate", "migrate local database based on pulled snapshot"
  method_options :real_emails => false
  def migrate
    if !File.exist?(dump_file)
      say "DB Dump is not present. Ending task."
      return
    end
    run_sql("SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid();")
    run("dropdb #{database}")
    run("createdb #{database}")
    run("pg_restore --no-owner --jobs=#{cpu_cores} -d #{database} #{dump_file}")
    run("rake db:migrate db:test:clone_structure")
  end

  desc "sync", "capture and pull latest production snapshot and migrate local database"
  def sync
    invoke :capture
    invoke :pull
    invoke :migrate
  end

  desc "fast_sync", "skip capturing and pull the latest existing production snapshot and migrate local database"
  def fast_sync
    invoke :pull
    invoke :migrate
  end
end