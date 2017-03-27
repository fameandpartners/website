class MicroInfluencerMailer < ActionMailer::Base

  default from: configatron.noreply

  def email(micro_influencer_form)
    @micro_influencer_form = micro_influencer_form

    email_address = configatron.micro_influencer_email_address
    mail(
      to:      email_address,
      from:    'team@fameandpartners.com',
      subject: '[Micro Influencer Application]',
      layout:  false
    )
  end
end
