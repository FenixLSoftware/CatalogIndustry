require 'sidekiq'
require 'sidekiq/web'
#require 'sidekiq-status'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["user@example.com", "changeme"]
end



Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379', db: Rails.env == 'staging' ? 1 : 0 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379', db: Rails.env == 'staging' ? 1 : 0 }
end

Sidekiq::Extensions.enable_delay!
