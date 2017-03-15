class MicroInfluencerMailer < ActionMailer::Base

  default from: configatron.noreply

  def email(micro_influencer_form)
    @micro_influencer_form = micro_influencer_form

    mail(
      to:      'influencerapplications@fameandpartners.com',
      from:    'team@fameandpartners.com',
      subject: '[Micro Influencer Application]',
      layout:  false
    )
  end
end
