require 'spec_helper'

RSpec.describe UserCart::ProductsController , :type => :controller do
  describe 'add gift to cart via ajax' do
    let!(:currency)        { SiteVersion.default.currency }
    let!(:order)           { create(:spree_order, currency: currency) }
    let!(:gift)            { create(:spree_product, name:"Gift", price: 0) }
    let!(:gift_variant)    { create(:spree_variant, product_id: gift.id, sku:"gift-Color:Casablanca") }

    it 'add gift to cart' do
      allow(controller).to receive(:current_order).and_return(order)
      expect(order.line_items.count).to eq(0)
      xhr :get, :check_gift_in_cart
      expect(response.body).to eq ("{\"has_gift\":false}")
      xhr :post, :create, { gift_sku: "gift-Color:Casablanca" }
      expect(order.line_items.count).to eq(1)
      xhr :get, :check_gift_in_cart
      expect(response.body).to eq ("{\"has_gift\":true}")
    end
  end
end
