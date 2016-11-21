require 'spec_helper'

describe 'show order', type: :feature do
  before(:each) do
    @user  = FactoryGirl.create(:spree_user)
    @order = FactoryGirl.create(:complete_order_with_items, id: 66, user_id: @user.id)

    shipment = FactoryGirl.build(:simple_shipment, order: @order)
    FactoryGirl.create(:inventory_unit, variant: @order.line_items.last.product.master, order: @order, shipment: shipment)

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
