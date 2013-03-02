require 'bundler/capistrano'
set :application, 'OpenSit'
set :user, 'deploy'
set :use_sudo, 'false'
set :domain, 'opensit.com'
set :applicationdir, "/var/www/vhosts/opensit.com/htdocs"
 
set :scm, 'git'
set :repository, "git@github.com:danbartlett/opensit.git"
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
 
# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true
 
# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache
 
# additional settings
#ssh_options[:keys] = %w(/home/user/.ssh/id_rsa)            # If you are using ssh_keysset :chmod755, "app config db lib public vendor script script/* public/disp*"set :use_sudo, false
 
# Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end