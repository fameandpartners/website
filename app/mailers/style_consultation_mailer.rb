class StyleConsultationMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def style_consultation(model)
    @style_consultation = model

    mail(
      to: 'team@fameandpartners.com',
      from: @style_consultation.email,
      subject: 'Style Consultation'
    )
  end
end
