class MarketingMailer < ActionMailer::Base
  self.delivery_method = :mandrill if Rails.env.production?

  include ProductsHelper

  layout 'mailer'
  helper :products

  default :from => configatron.noreply

  def abandoned_cart(order, user)
    @user = user
    @order = order
    site_version = order.get_site_version
    @site_version_code = site_version.default? ? '' : site_version.code

    mail(
      to: @user.email,
      subject: t('emails.subjects.marketing.abandoned_cart')
    )
  end

  def added_to_wishlist(user, site_version = nil)
    @user = user
    @wishlist = @user.wishlist_items
    @site_version = site_version || @user.recent_site_version

    mail(
      to: @user.email,
      subject: t('emails.subjects.marketing.added_to_wishlist')
    )
  end

  def style_quiz_completed(user, site_version = nil)
    @user = user
    @dresses = Spree::Product.recommended_for(@user, limit: 6)
    @site_version = site_version || @user.recent_site_version

    mail(
      to: @user.email,
      subject: t('emails.subjects.marketing.style_quiz_completed')
    )
  end

  def style_quiz_not_completed(user, site_version = nil)
    @user = user
    @site_version = site_version || @user.recent_site_version

    mail(
      to: @user.email,
      subject: t('emails.subjects.marketing.style_quiz_not_completed')
    )
  end
end
