class ContactMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(contact)
    @contact = contact

    mail(
      to: 'customerservice@fameandpartners.com',
      from: @contact.email,
      subject: "[#{@contact.site_version.upcase}] #{@contact.subject}",
      layout: false
    )
  end

  def join_team(contact)
    @contact = contact

    mail(
      to: 'talent@fameandpartners.com',
      from: @contact.email,
      subject: "[#{@contact.site_version.upcase}] Join team",
      layout: false
    )
  end

end
