source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'rspec-rails'
  gem 'faker'
  gem 'annotate', '2.5.0'
  gem 'meta_request', '0.2.1'
  # Guard shizzle
  gem 'rb-inotify', '~> 0.8.8' # Only needed on Linux. May need to install libnotify with OS's package manager
  gem 'guard'
  gem 'guard-rails'   # Reloads Rails server when cached files like those in /config change
  gem 'guard-livereload' # Sends signal to Livereload extension in browser to reload page
  gem 'guard-migrate' # Automatically runs migrations when needed
  gem 'guard-bundler' # Automatically installs/updates budler gems
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'capybara'
end

gem 'pg'

gem 'bootstrap-wysihtml5-rails'
gem 'bootstrap-datepicker-rails'

gem 'jquery-rails'

# Pagination
gem 'will_paginate'

# Devise authentication
gem 'devise'

# Classier solution for file uploads for Rails
gem 'carrierwave'
gem 'mini_magick'

# Simple form with country select
gem 'simple_form'
gem 'country_select'
gem 'chosen-rails'

# Rails admin
gem 'rails_admin'

gem 'turbolinks'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
