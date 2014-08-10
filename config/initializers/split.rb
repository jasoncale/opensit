Split.configure do |config|
  config.db_failover = true # handle redis errors gracefully
  config.db_failover_on_db_error = proc{|error| Rails.logger.error(error.message) }
  config.allow_multiple_experiments = true
  config.enabled = !Rails.env.test?
end

if ENV["REDISTOGO_URL"]
   uri = URI.parse(ENV["REDISTOGO_URL"])
   namespace = ["split", "opensit", Rails.env].join(":")

   redis = Redis.new(host: uri.host,
                     port: uri.port,
                     password: uri.password,
                     thread_safe: true
                    )

   redis_namespace = Redis::Namespace.new(namespace, redis: redis)

   Split.redis = redis_namespace
end