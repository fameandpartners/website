class Spree::ProductMailer < ActionMailer::Base

  include ApplicationHelper
  include PathBuildersHelper
  include ProductsHelper

  helper :application
  helper :products
  layout 'mailer'

  default :from => configatron.noreply

  def send_to_friend(product, friend_info, site_version = nil)
    @product = product
    @friend_info = friend_info
    @user_name = friend_info[:sender_name].to_s.titleize
    subject = if @user_name.present?
      "#{@user_name} wants you to approve of her dress at #{Spree::Config[:site_name]}"
    else
      "Review this dress at #{Spree::Config[:site_name]}"
    end

    @product_price = get_product_price(@product, site_version)
    @product_show_url = get_product_show_url(@product, site_version)

    mail(
      from: friend_info[:sender_email],
      to: friend_info[:email],
      subject: subject
    )
  end

  private

  def get_product_price(product, site_version = nil)
    if site_version.present?
      @product.site_price_for(site_version)
    else
      @product.price_in(Spree::Config[:currency])
    end
  end

  def get_product_show_url(product, site_version = nil)
    googleurl = "?utm_source=transactionalemail&utm_medium=email&utm_term=mum&utm_content=calltoaction&utm_campaign=sendtofriend"
    "#{ActionMailer::Base.default_url_options[:host]}#{collection_product_path(@product) + googleurl}"
  end
end
