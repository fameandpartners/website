class MyerStylingSessionMailer < ActionMailer::Base

  default from: configatron.noreply

  def email(myer_styling_session_form)
    @myer_styling_session_form = myer_styling_session_form

    mail(
      to:      'mystylist@fameandpartners.com',
      from:    'team@fameandpartners.com',
      subject: 'MYER appointment',
      layout:  false
    )
  end
end
