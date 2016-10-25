require 'sidekiq'

module NextLogistics
  module Workers
    class BaseWorker
      include Sidekiq::Worker

      sidekiq_options retry: false, backtrace: true
    end
  end
end
