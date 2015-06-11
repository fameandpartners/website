class StyleSessionMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(style_session)
    @style_session = style_session

    mail(
      to: 'team@fameandpartners.com',
      from: @style_session.email,
      subject: "[#{ @style_session.name.capitalize } Style Session Booking]",
      layout: false
    )
  end
end
