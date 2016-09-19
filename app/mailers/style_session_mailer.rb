class StyleSessionMailer < ActionMailer::Base

  default from: configatron.noreply

  def email(style_session_form)
    @style_session_form = style_session_form

    mail(
      to:      'mystylist@fameandpartners.com',
      from:    'team@fameandpartners.com',
      subject: '[Style Session Booking]',
      layout:  false
    )
  end
end
