class MarketingMailer < ActionMailer::Base
  self.delivery_method = :mandrill if Rails.env.production?

  include ProductsHelper

  layout 'mailer'
  helper :products

  default :from => configatron.noreply

  def abandoned_cart(order, user)
    @user = user
    @order = order

    mail(
      to: @user.email,
      subject: Spree::Config[:site_name] + ' ' + t('emails.subjects.marketing.abandoned_cart')
    )
  end

  def added_to_wishlist(user)
    @user = user
    @wishlist = @user.wishlist_items

    mail(
      to: @user.email,
      subject: Spree::Config[:site_name] + ' ' + t('emails.subjects.marketing.added_to_wishlist')
    )
  end

  def style_quiz_completed(user)
    @user = user
    @dresses = Spree::Product.recommended_for(@user, limit: 6)

    mail(
      to: @user.email,
      subject: Spree::Config[:site_name] + ' ' + t('emails.subjects.marketing.style_quiz_completed')
    )
  end

  def style_quiz_not_completed(user)
    @user = user

    mail(
      to: @user.email,
      subject: Spree::Config[:site_name] + ' ' + t('emails.subjects.marketing.style_quiz_not_completed')
    )
  end
end
