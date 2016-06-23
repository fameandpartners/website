class FameChainMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(fame_chain)
    @fame_chain = fame_chain

    mail(
      to: 'famechain@fameandpartners.com',
      from: @fame_chain.email,
      subject: '[Fame Chain]',
      layout: false
    )
  end
end
