class WeddingConsultationMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(wedding_consultation)
    @wedding_consultation = wedding_consultation

    mail(
      to:      'weddingstylist@fameandpartners.com',
      from:    @wedding_consultation.email,
      subject: '[Wedding Consultation]',
      layout:  false
    )
  end
end
