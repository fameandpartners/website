class BulkRefundMailer < ActionMailer::Base
  def report(results, user)
    email = 'finance@fameandpartners.com'
    subject = 'Bulk refund report'

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'bulk_refund_report_email',
      email_to:                    email,
      subject:                     subject,
      success:                     results[:success].map { |r| r[:item_return_id] },
      fails:                       results[:error].map { |r| [ r[:item_return_id], r[:result][:message] ] }
    )
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
  end
end
