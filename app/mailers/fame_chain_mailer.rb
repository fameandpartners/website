class FameChainMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def fame_chain(model)
    @fame_chain = model

    mail(
      to: 'famechain@fameandpartners.com',
      from: @fame_chain.email,
      subject: 'Fame Chain'
    )
  end
end
