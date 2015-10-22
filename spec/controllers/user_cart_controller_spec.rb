require 'spec_helper'

RSpec.describe UserCart::ProductsController , :type => :controller do
  describe 'add gift to cart via ajax' do
    let!(:currency)              { SiteVersion.default.currency }
    let!(:order)                 { create(:spree_order, currency: currency) }
    let!(:order_with_line_items) { create(:complete_order_with_items) }
    let!(:gift)                  { create(:spree_product, name:"Gift", price: 0) }
    let!(:gift_variant)          { create(:spree_variant, product_id: gift.id, sku:"gift-Color:Casablanca") }

    context 'user somehow adds a gift to an empty cart' do
      it 'should not add a gift to an empty cart' do
        allow(controller).to receive(:current_order).and_return(order)
        expect(order.line_items.size).to eq(0)
        xhr :get, :check_gift_in_cart
        expect(response.body).to eq ("{\"has_gift\":false}")
        xhr :post, :create, { gift_sku: "gift-Color:Casablanca" }
        xhr :get, :check_gift_in_cart
        expect(response.body).to eq ("{\"has_gift\":false}")
        expect(order.line_items.size).to eq(0)
      end
    end

    context 'user adds a gift to a non empty cart' do
      it 'add gift to non empty cart' do
        allow(controller).to receive(:current_order).and_return(order_with_line_items)
        expect(order_with_line_items.line_items.size).to eq(1)
        xhr :get, :check_gift_in_cart
        expect(response.body).to eq ("{\"has_gift\":false}")
        xhr :post, :create, { gift_sku: "gift-Color:Casablanca" }
        xhr :get, :check_gift_in_cart
        expect(response.body).to eq ("{\"has_gift\":true}")
        expect(order_with_line_items.line_items.size).to eq(2)
      end
    end
  end
end
