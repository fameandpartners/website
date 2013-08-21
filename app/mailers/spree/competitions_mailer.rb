class Spree::CompetitionsMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def invite(invitation)
    @invitation = invitation

    mail(:to => invitation.email, :subject => "Subject: Win a celebrity inspired formal outfit from Fame & Partners")
  end
end
