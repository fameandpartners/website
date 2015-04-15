#!/bin/env ruby
# encoding: utf-8

Spree::OrderMailer.class_eval do
  layout 'mailer', :except => [:team_confirm_email, :production_order_email]

  include Spree::BaseHelper
  include OrdersHelper

  helper 'spree/base'
  helper :orders

  def team_confirm_email(order)
    find_order(order)

    @additional_products_info = Bridesmaid::BoughtAdditionalProductsResource.new(order: @order).read

    to = 'team@fameandpartners.com'
    from = "#{@order.full_name} <#{@order.email}>"
    subject = "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    mail(to: to, from: from, subject: subject)
  end

  def production_order_email(order)
    find_order(order)

    to = configatron.order_production_emails
    from = configatron.noreply
    subject = "Order Confirmation (订单号码）##{@order.number}"

    mail(to: to, from: from, subject: subject)
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
end
