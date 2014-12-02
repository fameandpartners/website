class BridesmaidPartyMailer < ActionMailer::Base
  include ApplicationHelper
  include ProductsHelper

  layout 'mailer'
  default :from => configatron.noreply, :template_path => 'mailers/bridesmaid_party_mailer'

  def bridesmaid_send(bridesmaid_member, site_version)
    event         = bridesmaid_member.event
    bridesmaid    = bridesmaid_member.spree_user || Spree::User.where(email: bridesmaid_member.email).first
    product       = Spree::Variant.find(bridesmaid_member.variant_id).product
    color_option  = Spree::OptionValue.where(id: bridesmaid_member.color_id).first

    @bride_name   = bridesmaid.full_name
    @dress_name   = product.name
    @dress_price  = product.price
    @colour       = color_option.try(:name)
    @size         = Spree::OptionValue.where(id: bridesmaid_member.size).first.try(:name)
    @price        = product.zone_price_for(site_version).display_price

    images        = Repositories::ProductImages.new(product: product).read_all
    color_image   = images.find{|img| img.color_id == color_option.id}
    @image_url    = color_image.present? ? color_image.large : images.first.large

    mail(
      to: event.spree_user.email,
      subject: 'Bridesmaid Party'
    )
  end
end
