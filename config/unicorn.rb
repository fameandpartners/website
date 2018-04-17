# This config file is only for development, it will be overwritten as part of the deployment
raise "dev config file used in non dev environment" unless ENV.fetch('RAILS_ENV', 'development') == 'development'

# set path to application
app_dir = File.expand_path("../..", __FILE__)
working_directory app_dir

# Set unicorn options
worker_processes 3
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true
timeout 60

# Set up socket location
listen "127.0.0.1:3000", :tcp_nopush => true

# Logging
logger Logger.new($stdout)

check_client_connection false


# Set master PID location
pid "#{app_dir}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
    # the following is highly recommended for Rails + "preload_app true"
    # as there's no need for the master process to hold a connection
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end
  