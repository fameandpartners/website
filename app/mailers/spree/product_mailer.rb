class Spree::ProductMailer < ActionMailer::Base

  include ApplicationHelper
  include ProductsHelper
  helper :application
  helper :products
  layout 'mailer'

  default :from => configatron.noreply

  def send_to_friend(product, friend_info)
    @product = product
    @friend_info = friend_info
    @user_name = friend_info[:sender_name].to_s.titleize
    subject = if @user_name.present?
      "#{@user_name} wants you to approve of her dress at #{Spree::Config[:site_name]}"
    else
      "Review this dress at #{Spree::Config[:site_name]}"
    end
    mail(
      from: friend_info[:sender_email],
      to: friend_info[:email],
      subject: subject
    )
  end
end
