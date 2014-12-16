class BridesmaidPartyMailer < ActionMailer::Base
  include ApplicationHelper
  include ProductsHelper

  layout 'mailer'
  default :from => configatron.noreply, :template_path => 'mailers/bridesmaid_party_mailer'

  def bridesmaid_purchase(options = {})
    @items = options[:items]
    @bride = options[:bride]
    @user  = options[:user]

    mail(
      to: @bride.email,
      subject: 'Bridesmaid Party'
    )
  end

  def bridesmaid_send(bride, bridesmaid_member, site_version)
    event         = bridesmaid_member.event
    bridesmaid    = bridesmaid_member.spree_user || Spree::User.where(email: bridesmaid_member.email).first
    product       = Spree::Variant.find(bridesmaid_member.variant_id).product
    color_option  = Spree::OptionValue.where(id: bridesmaid_member.color_id).first

    @bride        = bride
    @bridesmaid_name = bridesmaid.full_name
    @dress_name   = product.name
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

  def invite(bridesmaid_member)
    email = bridesmaid_member.spree_user.try(:email) || bridesmaid_member.email
    @bride = bridesmaid_member.event.spree_user
    @membership = bridesmaid_member

    mail(
      to: email,
      subject: "WELCOME TO #{ @bride.first_name }'S BRIDESMAID PARTY".upcase
    )
  end
 
  def welcome(bride)
    mail(
      to: bride.email,
      subject: 'Welcome to Bridesmaid Party'
    )
  end

  private

    # helper methods. details fetching should be somewhere else
end

# dev code
# BridesmaidPartyMailer.welcome(Spree::User.last).deliver
# BridesmaidPartyMailer.invite(BridesmaidParty::Member.last).deliver
# BridesmaidPartyMailer.bridesmaid_send(BridesmaidParty::Member.last, SiteVersion.last).deliver
