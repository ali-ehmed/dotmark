if Rails.env == 'development'
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.disable_caching = false
end
# Rack::MiniProfiler.config.disable_caching = false
# Rack::MiniProfiler.config.use_existing_jquery = true
# Rack::MiniProfiler.config.skip_schema_queries = true