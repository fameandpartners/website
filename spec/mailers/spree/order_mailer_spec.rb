require 'spec_helper'

describe Spree::OrderMailer do

  let(:order) { create(:complete_order_with_items, projected_delivery_date: Date.today) }

  it 'send data to customerio correctly' do
    expected_attrs = { email_to: order.user.email,
                       subject:  "#{Spree::Config[:site_name]} #{I18n.t('order_mailer.confirm_email.subject')} ##{order.number}",
                       order_number: order.number,
                       line_items: Marketing::OrderPresenter.build_line_items(order),
                       display_item_total: order.display_item_total.to_s,
                       adjustments: Marketing::OrderPresenter.build_adjustments(order),
                       display_total: order.display_total.to_s,
                       auto_account: order.user && order.user.automagically_registered?,
                       today: Date.today.strftime("%d.%m.%y"),
                       billing_address: order.try(:billing_address).to_s  || 'No Billing Address',
                       shipping_address: order.try(:shipping_address).to_s || 'No Shipping Address',
                       phone: order.try(:billing_address).try(:phone) || 'No Phone',
                       delivery_date: order.projected_delivery_date.strftime("%a, %d %b %Y")
                        }
    expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(order.user, 'order_confirmation_email', expected_attrs)
    described_class.confirm_email(order)
  end

end
