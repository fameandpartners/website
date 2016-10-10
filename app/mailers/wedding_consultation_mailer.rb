class WeddingConsultationMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(wedding_consultation_form)
    @wedding_consultation_form = wedding_consultation_form

    mail(
      to:      'weddingstylist@fameandpartners.com',
      from:    'team@fameandpartners.com',
      subject: '[Wedding Consultation]',
      layout:  false
    )
  end
end
