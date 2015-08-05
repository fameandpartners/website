class BaseEmailMarketingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def log_mailer_error(error)
    NewRelic::Agent.notice_error(error)
    Rails.logger.info('mailer_error')
    Rails.logger.info(error.inspect)
    Rails.logger.info(error.backtrace)
    true
  end
end
