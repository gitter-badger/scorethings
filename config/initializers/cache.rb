require 'dalli'
if Rails.env.production?
  # using doc article from heroku: https://devcenter.heroku.com/articles/memcachier
  cache = Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
                            {:username => ENV["MEMCACHIER_USERNAME"],
                             :password => ENV["MEMCACHIER_PASSWORD"],
                             :failover => true,
                             :socket_timeout => 1.5,
                             :socket_failure_delay => 0.2
                            })
else
  cache = Dalli::Client.new('localhost:11211',
                            {:failover => true,
                             :socket_timeout => 1.5,
                             :socket_failure_delay => 0.2
                            })
end
