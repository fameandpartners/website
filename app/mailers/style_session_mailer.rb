class StyleSessionMailer < ActionMailer::Base

  default from: configatron.noreply

  def email(style_session)
    @style_session = style_session

    mail(
      to:      'mystylist@fameandpartners.com',
      from:    'team@fameandpartners.com',
      subject: '[Style Session Booking]',
      layout:  false
    )
  end
end
