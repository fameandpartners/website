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

    line_items = Marketing::OrderPresenter.build_line_items(@order)
    adjustments = Marketing::OrderPresenter.build_adjustments(@order)

    user = @order.user
    user ||= Spree::User.where(email: @order.email).first

    begin
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
        auto_account:       user && user.automagically_registered?,
        today:              Date.today.to_formatted_s(:long)
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
  end

  def team_confirm_email(order)
    find_order(order)

    @order_presenter = Orders::OrderPresenter.new(@order)

    subject = "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    line_items = Marketing::OrderPresenter.build_line_items(@order)
    adjustments = Marketing::OrderPresenter.build_adjustments(@order)

    user = @order.user
    user ||= Spree::User.where(email: @order.email).first

    begin
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
        # TODO: additional products info was a bridesmaid reference.
        additional_products_info:       false,
        additional_products_info_data:  [],
        phone_present:                  @order.billing_address.present? ? @order.billing_address.phone.present? : false,
        phone:                          @order.billing_address.present? ? @order.billing_address.phone : '',
        billing_address:                @order.billing_address.to_s,
        shipping_address:               @order.shipping_address.to_s,
        required_to_present:            @order.required_to.present?,
        required_to:                    @order.required_to
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
  end

  def production_order_email(order, factory, items)
    find_order(order)

    subject = "Order Confirmation (订单号码）(#{factory}) ##{@order.number}"

    user = @order.user
    user ||= Spree::User.where(email: @order.email).first

    customer_notes = @order.customer_notes?
    @order = Orders::OrderPresenter.new(@order, items)
    line_items = Orders::OrderPresenter.build_line_items_for_production(@order)

    begin
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
        customer_notes:      customer_notes,
        customer_note_data:  @order.customer_notes,
        customer:            @order.name,
        phone:               @order.phone_number,
        shipping_address:    @order.shipping_address,
        factory:             factory
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
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
