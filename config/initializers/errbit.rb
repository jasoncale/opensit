Airbrake.configure do |config|
  config.api_key = '150d8b22012d02c7406c85e2262ca05b'
  config.host    = 'fixerr.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
