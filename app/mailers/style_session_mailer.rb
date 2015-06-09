class StyleSessionMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(style_session)
    @style_session = style_session

    @subject =  case style_session.session_type.to_s.downcase
                when 'birthday'
                  "Birthday Style Session Booking"
                when 'prom'
                  "Prom Style Session Booking"
                else
                  "Style Session Booking"
                end

    mail(
      to: 'team@fameandpartners.com',
      from: @style_session.email,
      subject: "[#{ @subject }]",
      layout: false
    )
  end
end
