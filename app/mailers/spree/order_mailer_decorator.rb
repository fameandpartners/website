#!/bin/env ruby
# encoding: utf-8

Spree::OrderMailer.class_eval do
  layout 'mailer', :except => [:team_confirm_email]

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

    # TODO: `.build_line_items` and `.build_adjustments` should be Marketing::OrderPresenter's instance methods
    # TODO: maybe these order presenters are very specific for emails...should the name "Marketing" be rethinked?
    order_presenter = Marketing::OrderPresenter.new(@order)
    line_items      = Marketing::OrderPresenter.build_line_items(@order)
    adjustments     = Marketing::OrderPresenter.build_adjustments(@order)

    user = @order.user
    user ||= Spree::User.where(email: @order.email).first

    begin
      Marketing::CustomerIOEventTracker.new.track(
        user,
        'order_confirmation_email',
        email_to:                    order_presenter.email,
        subject:                     subject,
        order_number:                order_presenter.number,
        line_items:                  line_items,
        display_item_total:          @order.display_item_total.to_s,
        adjustments:                 adjustments,
        display_total:               @order.display_total.to_s,
        auto_account:                user && user.automagically_registered?,
        today:                       Date.today.strftime('%d.%m.%y'),
        phone:                       @order.try(:billing_address).try(:phone) || 'No Phone',
        delivery_date:               @order.projected_delivery_date.try(:strftime, '%a, %d %b %Y'),
        billing_address_attributes:  order_presenter.billing_address.to_h,
        shipping_address_attributes: order_presenter.shipping_address.to_h,
        billing_address:             @order.try(:billing_address).to_s || 'No Billing Address',
        shipping_address:            @order.try(:shipping_address).to_s || 'No Shipping Address',
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
      Raven.capture_exception(e)
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
        display_item_total:             @order.display_item_total.to_s,
        promotion:                      @order_presenter.promotion?,
        promocode:                      @order_presenter.promo_codes.join(', '),
        adjustments:                    adjustments,
        display_total:                  @order.display_total.to_s,
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
      Raven.capture_exception(e)
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
