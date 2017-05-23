class Spree::CompetitionsMailer < ActionMailer::Base
  layout 'mailer', except: [:marketing_email]

  default :from => configatron.noreply

  def invite(invitation)
    @invitation = invitation

    mail(:to => invitation.email, :subject => "Win a celebrity inspired formal outfit from Fame and Partners")
  end

  def marketing_email(email)
    mail(:to => email, :subject => "Win a celebrity inspired formal outfit from Fame and Partners")
  end
end
