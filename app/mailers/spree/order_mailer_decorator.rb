#!/bin/env ruby
# encoding: utf-8

Spree::OrderMailer.class_eval do
  layout 'mailer', :except => [:team_confirm_email, :production_order_email]

  include Spree::BaseHelper
  include OrdersHelper
  include ApplicationHelper

  helper 'spree/base'
  helper :orders
  helper :application

  attr_reader   :order
  helper_method :order

  def build_line_items
    line_items = []
    @order.line_items.each do |item|
      line_item = {}
      line_item[:sku]                    = item.variant.sku
      line_item[:name]                   = item.variant.product.name
      line_item[:making_options_text]    = item.making_options_text
      line_item[:options_text]           = item.options_text
      line_item[:quantity]               = item.quantity
      line_item[:variant_display_amount] = item.variant.display_amount
      line_item[:display_amount]         = item.display_amount
      line_items << line_item
    end
    line_items
  end

  def build_line_items_for_production
    line_items = []
    @order.line_items.each do |item|
      line_item = {}
      line_item[:style_num]                   = item.style_number
      line_item[:size]                        = item.country_size
      line_item[:adjusted_size]               = item.make_size
      line_item[:color]                       = item.colour_name
      line_item[:quantity]                    = item.quantity
      line_item[:factory]                     = item.factory
      line_item[:deliver_date]                = @order.projected_delivery_date
      if item.making_options.present?
        line_item[:express_making] = item.making_options.map{|option| option.name.upcase }.join(', ')
      end

      customizations = []

      item.customisations.each do |name, image_url|
        item_customization = {}
        item_customization[:name] = name
        item_customization[:url]  = image_url
        customizations << item_customization
      end

      line_item[:customizations] = customizations

      if item.image?
        line_item[:image_url] = item.image_url
      end

      line_items << line_item
    end
    line_items
  end

  def build_adjustments
    adjustments = []
    @order.adjustments.eligible.each do |adjustments_item|
      adjustment = {}
      adjustment[:label]          = adjustments_item.label
      adjustment[:display_amount] = adjustments_item.display_amount
      adjustments << adjustment
    end
    adjustments
  end

  def build_additional_products_info
    additional_products_info = []
    if @additional_products_info.present?
      info = {}
      @additional_products_info.each do |info_item|
        info[:product] = info_item.product
        info[:email] = info_item.email
        info[:phone] = info_item.phone
        info[:state] = info_item.state
      end
      additional_products_info << info
    end
    additional_products_info
  end

  def confirm_email(order, resend = false)
    find_order(order)
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    user = @order.user
    line_items = build_line_items
    adjustments = build_adjustments

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'order_confirmation_email',
      email_to:           @order.email,
      subject:            subject,
      order_number:       @order.number,
      line_items:         line_items,
      display_item_total: @order.display_item_total,
      adjustments:        adjustments,
      display_total:      @order.display_total,
      auto_account:       @order.user && @order.user.automagically_registered?,
      today:              Date.today.to_formatted_s(:long)
    )
  end

  def team_confirm_email(order)
    find_order(order)

    @additional_products_info = Bridesmaid::BoughtAdditionalProductsResource.new(order: @order).read

    @order_presenter = Orders::OrderPresenter.new(@order)

    to = 'team@fameandpartners.com'
    from = "#{@order.full_name} <#{@order.email}>"
    subject = "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    user = @order.user
    line_items = build_line_items
    adjustments = build_adjustments
    additional_products_info = build_additional_products_info

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'order_team_confirmation_email',
      email_to:                       "team@fameandpartners.com",
      subject:                        subject,
      line_items:                     line_items,
      display_item_total:             @order.display_item_total,
      promotion:                      @order_presenter.promotion?,
      promocode:                      @order_presenter.promo_codes.join(', '),
      adjustments:                    adjustments,
      display_total:                  @order.display_total,
      additional_products_info:       @additional_products_info.present?,
      additional_products_info_data:  additional_products_info,
      phone_present:                  @order.billing_address.phone.present?,
      phone:                          @order.billing_address.phone,
      billing_address:                @order.billing_address.to_s,
      shipping_address:               @order.shipping_address.to_s,
      required_to_present:            @order.required_to.present?,
      required_to:                    @order.required_to
    )
  end

  def production_order_email(order, factory, items)
    find_order(order)

    to = configatron.order_production_emails
    from = configatron.noreply
    subject = "Order Confirmation (订单号码）(#{factory}) ##{@order.number}"

    user = @order.user
    customer_notes = @order.customer_notes?
    @order = Orders::OrderPresenter.new(@order, items)
    line_items = build_line_items_for_production

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'order_production_order_email',
      email_to:            configatron.order_production_emails,
      subject:             subject,
      number:              @order.number,
      site:                @order.site_version,
      total_items:         @order.total_items,
      promotion:           @order.promotion?,
      promocode:           @order.promo_codes.join(', '),
      line_items:          line_items,
      customer_notes:       customer_notes,
      customer_note_data:  @order.customer_notes,
      customer:            @order.name,
      phone:               @order.phone_number,
      shipping_address:    @order.shipping_address,
      factory:             factory
    )
  end


  def guest_payment_request(payment_request, resubmission = false)
    @payment_request = payment_request
    @resubmission = resubmission
    find_order(payment_request.order_id)

    to = "#{@payment_request.recipient_full_name} <#{@payment_request.recipient_email}>"
    from = "#{@order.full_name} <#{@order.email}>"

    if @resubmission
      subject = "Can you please pay for my order at #{Spree::Config[:site_name]}?"
    else
      subject = "Can you please pay for my order at #{Spree::Config[:site_name]}?"
    end

    mail(to: to, from: from, subject: subject)
  end

  def send_to_friend(products, email)
    @products = products
    subject = "Your daughter sent you her favourite Quinceanera dresses"
    mail to:      email,
         from:    configatron.noreply,
         subject: subject
  end
end
