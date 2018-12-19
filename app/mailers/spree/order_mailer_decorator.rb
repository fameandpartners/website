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
    order_presenter = Marketing::OrderPresenter.new(@order)
    user = @order.user || Spree::User.where(email: @order.email).first
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    begin
      Marketing::CustomerIOEventTracker.new.track(
        user,
        'order_confirmation_email',
        email_to:                    order_presenter.email,
        subject:                     subject,
        order_number:                order_presenter.number,
        line_items:                  order_presenter.build_line_items,
        display_item_total:          order_presenter.display_item_total,
        adjustments:                 order_presenter.build_adjustments,
        display_total:               order_presenter.display_total,
        auto_account:                user && user.automagically_registered?,
        today:                       Time.zone.today.strftime('%d.%m.%y'),
        phone:                       order_presenter.phone,
        billing_address_attributes:  order_presenter.billing_address_attributes.to_h,
        shipping_address_attributes: order_presenter.shipping_address_attributes.to_h,
        billing_address:             order_presenter.billing_address,
        shipping_address:            order_presenter.shipping_address,
        all_fabric_swatches:         order_presenter.all_fabric_swatches?
      )
    rescue StandardError => e
      Rails.logger.error e
      Raven.capture_exception(e)
    end
  end

  def team_confirm_email(order)
    find_order(order)
    order_presenter = Marketing::OrderPresenter.new(@order)
    user = @order.user || Spree::User.where(email: @order.email).first
    subject = "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    begin
      Marketing::CustomerIOEventTracker.new.track(
        user,
        'order_team_confirmation_email',
        email_to:                       "team@fameandpartners.com",
        subject:                        subject,
        line_items:                     order_presenter.build_line_items,
        display_item_total:             order_presenter.display_item_total,
        promotion:                      order_presenter.promotion?,
        promocode:                      order_presenter.promo_codes.join(', '),
        adjustments:                    order_presenter.build_adjustments,
        display_total:                  order_presenter.display_total,
        # TODO: additional products info was a bridesmaid reference.
        additional_products_info:       false,
        additional_products_info_data:  [],
        phone_present:                  order_presenter.phone_present?,
        phone:                          order_presenter.phone,
        billing_address:                order_presenter.billing_address,
        shipping_address:               order_presenter.shipping_address,
        required_to_present:            order_presenter.required_to.present?,
        required_to:                    order_presenter.required_to,
      )
    rescue StandardError => e
      Rails.logger.error e
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
