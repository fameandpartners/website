class DailyReportMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(report_full_name, report_filename, report_type)
    mail.attachments[report_filename] = File.read(report_full_name)
    mail(
      to: 'orders@fameandpartners.com.cn, bens@fameandpartners.com',
      subject: "Daily orders report #{Date.today.to_date} #{report_type}",
      layout: false
    )
  end

end
