# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Opensit::Application.initialize!

config.assets.precompile += %w( font-awesome.css )
