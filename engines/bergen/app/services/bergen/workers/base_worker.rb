require 'sidekiq'

module Bergen
  module Workers
    class BaseWorker
      include Sidekiq::Worker

      sidekiq_options retry: 1, backtrace: true
    end
  end
end
