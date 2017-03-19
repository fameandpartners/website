class MicroInfluencerMailer < ActionMailer::Base

  default from: configatron.noreply

  def email(micro_influencer_form)
    @micro_influencer_form = micro_influencer_form

    email_address = 'influencerapplications@fameandpartners.com'
    email_address = 'qa@fameandpartners.com' unless RAILS_ENV == 'production'
    
    mail(
      to:      email_address
      from:    'team@fameandpartners.com',
      subject: '[Micro Influencer Application]',
      layout:  false
    )
  end
end
