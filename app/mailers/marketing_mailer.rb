class MarketingMailer < ActionMailer::Base
  # TODO: there's no mandrill config anymore. Any emails trying to use this will raise errors. Watch it.
  self.delivery_method = :mandrill if Rails.env.production?

  include ProductsHelper
  include ApplicationHelper
  include PathBuildersHelper

  layout 'mailer'
  helper :products
  helper :application

  #require 'lib/products/similar_products'
  require File.join(Rails.root, 'lib', 'products', 'similar_products.rb')

  default :from => configatron.noreply

  def abandoned_cart(order, user)
    product      = order.line_items.first.product
    site_version = order.get_site_version
    base_price   = product.site_price_for(site_version)
    image_urls   = Products::ColorVariantImageDetector.cropped_images_for(product).collect { |i| i.attachment.url(:large) }

    # Template Scope
    @resume_shop_url   = root_url(site_version: site_version.to_param)
    @product_url       = collection_product_url(product, site_version: site_version.to_param, faadc: 'buyit10', skip_reminder:'true')
    @product_image_url = image_urls.sample
    @product_name      = product.name
    @original_price    = base_price.display_price
    @discounted_price  = Spree::Money.new(base_price.amount - base_price.amount * 0.1)

    subject = t('emails.subjects.marketing.abandoned_cart')

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'abandoned_cart',
      email:             user.email,
      subject:           subject,
      resume_shop_url:   @resume_shop_url,
      product_url:       @product_url,
      product_image_url: @product_image_url,
      product_name:      @product_name,
      original_price:    @original_price,
      discounted_price:  @discounted_price
    )

  end

  def added_to_wishlist(user, site_version = nil)
    @user = user
    @wishlist = @user.wishlist_items
    @site_version = site_version || @user.recent_site_version

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: @user.email,
        subject: t('emails.subjects.marketing.added_to_moodboard')
      )
    end
  end

  def style_quiz_completed(user, site_version = nil)
    @user = user
    @dresses = Spree::Product.recommended_for(@user, limit: 6)
    @site_version = site_version || @user.recent_site_version

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: @user.email,
        subject: t('emails.subjects.marketing.style_quiz_completed')
      ) do |format|
        format.html{ render layout: false }
      end
    end
  end

  def style_quiz_completed_reminder(user, site_version = nil)
    return if user.nil?
    @user = user
    @site_version = site_version || @user.recent_site_version
    @site_version_code = @site_version.default? ? '' : @site_version.code
    @recommended_dresses = Spree::Product.active.featured.limit(6)

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: @user.email,
        subject: t('emails.subjects.marketing.style_quiz_completed_reminder')
      )
    end
  end

  def style_quiz_not_completed(user, site_version = nil)
    @user = user
    @site_version = site_version || @user.recent_site_version

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: @user.email,
        subject: t('emails.subjects.marketing.style_quiz_not_completed')
      )
    end
  end

  def wishlist_item_added(user, item, site_version = nil)
    @user = user
    @product = item.product
    @site_version = site_version || @user.recent_site_version
    @site_version_code = @site_version.default? ? '' : @site_version.code
    @images = (@product.images * 5).first(5)
    @personalisation_url = "#{ main_app.root_url(site_version: @site_version_code) }/#{ personalization_product_path(permalink: @product.permalink) }"

    @recommended_dresses = Products::SimilarProducts.new(@product).fetch(6).to_a
    if @recommended_dresses.blank?
      @recommended_dresses = Spree::Product.active.featured.limit(6)
    end

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: @user.email,
        subject: t('emails.subjects.marketing.wishlist_item_added')
      )
    end
  end

  def wishlist_item_added_reminder(user, item, site_version = nil)
    @user = user
    @product = item.product
    @site_version = site_version || @user.recent_site_version
    @site_version_code = @site_version.default? ? '' : @site_version.code
    @images = (@product.images * 5).first(5)
    @personalisation_url = "#{ main_app.root_url(site_version: @site_version_code) }/#{ personalization_product_path(permalink: @product.permalink) }"
    @recommended_dresses = Products::SimilarProducts.new(@product).fetch(6).to_a

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: @user.email,
        subject: t('emails.subjects.marketing.wishlist_item_added_reminder')
      )
    end
  end

  def bridesmaids_consultation_form(email)
    mail to: email,
         subject: "Wedding consultation"
  end
end
