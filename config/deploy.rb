require "rvm/capistrano"
require "bundler/capistrano"
load "deploy/assets"

set :application, 'OpenSit'
set :user, 'deploy'
set :use_sudo, 'false'
set :domain, 'opensit.com'
set :applicationdir, "/var/www/vhosts/opensit.com/htdocs"
set :rails_env, :production
 
set :scm, 'git'
set :repository, "https://github.com/danbartlett/opensit.git"
set :branch, 'master'
set :scm_verbose, true
 
# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true
 
# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache
 
# additional settings
default_run_options[:pty] = true
#ssh_options[:keys] = %w(/home/user/.ssh/id_rsa)            # If you are using ssh_keysset :chmod755, "app config db lib public vendor script script/* public/disp*"set :use_sudo, false
 
# Passenger
namespace :deploy do
  after :update_code, :symlink_db
  after :update_code, :precompile_assets

  task :precompile_assets do
    run "cd #{release_path}; rake assets:precompile RAILS_ENV=production"
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end