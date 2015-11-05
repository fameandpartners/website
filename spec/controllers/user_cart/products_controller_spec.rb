require 'spec_helper'

module UserCart
  describe ProductsController , :type => :controller do
    describe 'add gift to cart via ajax' do
      let!(:shipping_method)       { Spree::ShippingMethod.create(name: 'test') }
      let!(:currency)              { SiteVersion.default.currency }
      let!(:order)                 { create(:spree_order, currency: currency, shipping_method: shipping_method.id) }
      let!(:order_with_line_items) { create(:complete_order_with_items) }
      let!(:gift)                  { create(:spree_product, name:"Gift", price: 0) }
      let!(:gift_variant)          { create(:spree_variant, product_id: gift.id, sku:"gift-Color:Casablanca") }

      let(:product)                { create(:dress) }
      let!(:variant)               { create(:spree_variant, product_id: product.id, sku: 'my-test-sku') }
      let!(:variant2)              { create(:spree_variant, product_id: product.id, sku: 'my-test-sku2') }
      let!(:line_item_personalization) { LineItemPersonalization.new(id: 1)}

      context 'user add a dress to cart ' do
        it 'add one line item to order per add to cart request' do
          allow(controller).to receive(:current_order).and_return(order)
          allow_any_instance_of(LineItemPersonalization).to receive(:run_validations!).and_return(true)
          allow_any_instance_of(LineItemPersonalization).to receive(:add_plus_size_cost?).and_return(true)
          allow_any_instance_of(LineItemPersonalization).to receive(:calculate_size_cost).and_return(0)
          allow_any_instance_of(Spree::Order).to receive(:update!).and_return(true)
          allow_any_instance_of(UserCart::Populator).to receive(:validate!).and_return(true)
          allow_any_instance_of(UserCart::Populator).to receive(:personalized_product?).and_return(true)
          allow_any_instance_of(UserCart::Populator).to receive(:build_personalization).and_return(line_item_personalization)

          line_item_personalization.id = 1
          line_item_personalization.line_item_id= 1
          line_item_personalization.product_id= product.id


          expect(order.line_items.size).to eq(0)
          xhr :post, :create, { variant_id: variant.id, quantity: 1 }
          expect(order.line_items.size).to eq(1)
          xhr :post, :create, { variant_id: variant.id, quantity: 1 }
          expect(order.line_items.size).to eq(2)
          xhr :post, :create, { variant_id: variant2.id, quantity: 1 }
          expect(order.line_items.size).to eq(3)
        end
      end

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
end
