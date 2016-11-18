require 'spec_helper'

describe 'show order', type: :feature do
  before(:each) do
    unless Spree::PaymentMethod.exists?
      FactoryGirl.create(:simple_payment_method)
    end

    unless Spree::ShippingMethod.exists?
      FactoryGirl.create(:simple_shipping_method)
    end

    @order = Spree::Order.create!(email: 'test@fameandpartners.com')
    @user  = FactoryGirl.create(:spree_user)

    line_item = FactoryGirl.create(:dress_item)
    @order.line_items << line_item
    @order.save
    @order.next!

    @order.bill_address = FactoryGirl.create(:address)
    @order.ship_address = FactoryGirl.create(:address)
    @order.next!

    @order.shipping_method = Spree::ShippingMethod.first

    @order.payments.create!({ payment_method: Spree::PaymentMethod.first, amount: @order.total }, without_protection: true)
    @order.payment_state = 'paid'
    @order.next!

    @order.update_attribute(:user_id, @user.id)
    @order.shipments.destroy_all

    shipment = FactoryGirl.create(:simple_shipment)
    FactoryGirl.create(:inventory_unit, variant: line_item.product.master, order: @order, shipment: shipment)

    shipment.order = @order
    shipment.save!

    allow_any_instance_of(Spree::OrdersController).to receive(:current_user).and_return(@user)
    allow_any_instance_of(Spree::OrdersController).to receive(:authorize!).and_return(true)
  end

  it 'can visit an order' do
    expect { visit spree.order_path(@order) }.not_to raise_error
    expect(page.status_code).to eq(200)
  end


  # NOTE: 18/11/16 - Alexey Bobyrev
  # Regression test for PR #2169
  it 'with enabled I=C feature page should be available to visit' do
    Features.activate(:i_equal_change)
    expect { visit spree.order_path(@order, force_tracking: true) }.not_to raise_error
    expect(page.status_code).to eq(200)
  end

  it 'should display line item price' do
    line_item = @order.line_items.first
    line_item.price = 19.00
    line_item.save!
    @order.update_totals
    @order.save

    visit spree.order_path(@order)

    within '.total-info .amount' do
      expect(page).to have_content '$19.00'
    end
  end

  it 'should return the correct title when displaying a completed order' do
    visit spree.order_path(@order)

    within '.order-number' do
      expect(page).to have_content("Order # #{@order.number}")
    end
  end

  it 'should show state text' do
    visit spree.order_path(@order)

    within '.order-info' do
      expect(page).to have_content(@order.bill_address.state.name)
      expect(page).to have_content(@order.ship_address.state.name)
    end
  end

end
