# Load the rails application
require File.expand_path('../application', __FILE__)

require File.join(Rails.root, 'app', 'repositories', 'caching_system.rb')

# Initialize the rails application
FameAndPartners::Application.initialize!

ActiveRecord::Base.include_root_in_json = true

# if defined?(PhusionPassenger)
#   PhusionPassenger.on_event(:starting_worker_process) do |forked|
#     if forked and defined?(Sidekiq)
#       Rails.logger.error('INFO: reconnect sidekiq')
#       Sidekiq.redis do |r|
#         r.client.reconnect
#       end
#     end
#   end
# end
