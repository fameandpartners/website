class BulkRefundMailer < ActionMailer::Base
  def report(events)
    email = ''
    subject = 'Bulk refund report'

    Marketing::CustomerIOEventTracker.new.track(
      nil,
      'bulk_refund_report_email',
      email_to:                    email,
      subject:                     subject,
      events:                      events.map(&:id)
    )
  rescue StandardError => e
    binding.pry
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
  end
end
