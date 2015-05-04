class ContactMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(contact)
    @contact = contact

    mail(
      to: 'team@fameandpartners.com',
      from: @contact.email,
      subject: "[#{@contact.site_version.upcase}] #{@contact.subject}",
      layout: false
    )
  end
end
