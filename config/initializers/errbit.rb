Airbrake.configure do |config|
  config.api_key = '7a0d691718490b148933437775d917ab'
  config.host    = 'fixerr.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
