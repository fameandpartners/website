worker_processes 3
working_directory "/app"

listen "/app/tmp/unicorn.sock", :backlog => 512
listen 3000, :tcp_nopush => true

timeout (ENV["UNICORN_TIMEOUT"] || 120).to_i

pid "/app/tmp/unicorn.pid"

stderr_path "/app/log/unicorn.stderr.log"
stdout_path "/app/log/unicorn.stdout.log"
logger Logger.new($stdout)

run_path = "/app"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{run_path}/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
  Resque.redis.quit if defined?(Resque)
end

 before_exec do |server|
    ENV['BUNDLE_GEMFILE'] = "/app/Gemfile"
 end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  if defined?(Sidekiq) &&
    Gem::Version.new(Sidekiq::VERSION) < Gem::Version.new("2.9")

    Sidekiq.configure_client do |config|
      config.redis = ConnectionPool.new(size: 1, timeout: 5) do
        Redis.new({ :url => ENV['REDIS_URL'] || 'redis://localhost:6379', :namespace => "fandp_web-#{Rails.env}" })
      end
    end
  end

  Resque.redis = ENV['REDIS_URL'] if defined?(Resque)
end
