class BaseEmailMarketingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def log_mailer_error(error)
    puts error.inspect
    puts error.backtrace.inspect
    true
  end
end
