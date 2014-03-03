source 'https://rubygems.org'
ruby "2.0.0"

gem 'rails', '4.0.0'
gem 'rack'
gem 'puma'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'annotate'
  gem 'meta_request', '0.2.6'
  gem 'jazz_hands'
  gem 'pry-coolline'

  # Guard shizzle
  gem 'rb-inotify', '~> 0.9', require: false # Only needed on Linux. May need to install libnotify with OS's package manager
  gem 'rb-fsevent', require: false # For OS X
  gem 'guard', '>=2.1.0'
  gem 'guard-rspec' # Automatically runs specs when corresponding files change
  gem 'guard-rails'   # Reloads Rails server when cached files like those in /config change
  gem 'guard-livereload' # Sends signal to Livereload extension in browser to reload page
  gem 'guard-migrate' # Automatically runs migrations when needed
  gem 'terminal-notifier-guard', require: false
end

# Previously assets group
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'therubyracer'
gem 'uglifier', '>= 1.0.3'
gem 'bootstrap-datepicker-rails'
gem 'font-awesome-sass'

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker' # Generates names, emails and other placeholders for factories
  gem 'shoulda-matchers'
  gem 'poltergeist', '~> 1.4.0'
  gem 'launchy'
end

gem 'pg'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'protected_attributes' # Smoother upgrade to rails 4, provides attr_accessible
gem 'textacular'

# Devise authentication
gem 'devise'

# Classier solution for file uploads for Rails
gem 'paperclip'
gem 'aws-sdk'
gem 'mini_magick'

# Simple form with country select
gem 'simple_form'
gem 'country_select'
gem 'chosen-rails'
gem 'compass-rails', github: 'Compass/compass-rails' # Required by chosen, needs to be explicit
gem 'bootstrap-wysihtml5-rails'
gem "jquery-rails", "2.3.0"

# Pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# Admin/tracking
gem 'newrelic_rpm'
gem 'airbrake'

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano'

# Heroku assets and logging
gem 'rails_12factor', group: :production