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

  def confirm_email(order, resend = false)
    find_order(order)
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    user = @order.user
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

    adjustments = []
    @order.adjustments.eligible.each do |adjustments_item|
      adjustment = {}
      adjustment[:label]          = adjustments_item.label
      adjustment[:display_amount] = adjustments_item.display_amount
      adjustments << adjustment
    end

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
      auto_account:       @order.user && @order.user.automagically_registered?
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
    Marketing::CustomerIOEventTracker.new.track(
      user,
      'order team confirmation email',
      email_to:             "team@fameandpartners.com",
       subject:             subject
    )
    #mail(to: to, from: from, subject: subject)
  end

  def production_order_email(order, factory, items)
    find_order(order)

    to = configatron.order_production_emails
    from = configatron.noreply
    subject = "Order Confirmation (订单号码）(#{factory}) ##{@order.number}"

    user = @order.user
    @order = Orders::OrderPresenter.new(@order, items)

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'order production order email',
      email_to:             configatron.order_production_emails,
       subject:             subject
    )
    #mail(to: to, from: from, subject: subject)
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
