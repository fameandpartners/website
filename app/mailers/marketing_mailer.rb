class MarketingMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def abandoned_cart
    mail(
      to: 'example@example.com',
      subject: 'Abandoned Cart'
    )
  end

  def added_to_wishlist
    mail(
      to: 'example@example.com',
      subject: 'Added to wishlist'
    )
  end

  def style_quiz_completed
    mail(
      to: 'example@example.com',
      subject: 'Style quiz completed'
    )
  end

  def style_quiz_not_completed
    mail(
      to: 'example@example.com',
      subject: 'Style quiz do not completed'
    )
  end
end
