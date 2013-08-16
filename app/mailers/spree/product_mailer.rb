class Spree::ProductMailer < ActionMailer::Base
  layout 'mailer'

  include ApplicationHelper
  include ProductsHelper
  helper :application
  helper :products

  default :from => configatron.noreply

  def send_to_friend(user, product, friend_info)
    @product = product
    @friend_info = friend_info
    @user_name = @user.try(:fullname) || Spree::Config[:site_name]

    mail(
      to: @friend_info[:email],
      subject: "#{@user_name} wants you to approve of her dress at #{Spree::Config[:site_name]}"
    )
  end
end
