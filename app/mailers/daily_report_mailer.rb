class DailyReportMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(file, report_filename, report_type)
    file.rewind
    mail.attachments[report_filename] = file.read
    mail(
      to: 'orders@fameandpartners.com.cn, bens@fameandpartners.com',
      subject: "Daily orders report #{Date.today.to_date} #{report_type}",
      layout: false
    )
  end

end
