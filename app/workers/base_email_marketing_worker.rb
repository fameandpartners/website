class BaseEmailMarketingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def log_mailer_error(error)
    Rails.logger.info('mailer_error')
    Rails.logger.debug(error.inspect)
    Rails.logger.debug(error.backtrace)
    true
  end
end
