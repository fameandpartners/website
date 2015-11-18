require 'spec_helper'

module UserCart
  describe ProductsController, :type => :controller do
    let(:order)                        { create(:spree_order) }
    before(:each)                      { allow(controller).to receive(:current_order).and_return(order) }

    describe 'user add a dress to cart ' do
      let!(:product)                   { create(:dress) }
      let!(:variant)                   { create(:spree_variant, product_id: product.id, sku: 'my-test-sku') }
      let!(:variant2)                  { create(:spree_variant, product_id: product.id, sku: 'my-test-sku2') }
      let!(:line_item_personalization) { LineItemPersonalization.new }

      before(:each) do
        allow_any_instance_of(Spree::Order).to receive(:update!).and_return(true)

        allow_any_instance_of(LineItemPersonalization).to receive_messages(
                                                              run_validations!:    true,
                                                              add_plus_size_cost?: true,
                                                              calculate_size_cost: 0
                                                          )
        allow_any_instance_of(UserCart::Populator).to receive_messages(
                                                          validate!:             true,
                                                          personalized_product?: true,
                                                          build_personalization: line_item_personalization
                                                      )
      end

      it 'add one line item to order per add to cart request' do
        expect(order.line_items.size).to eq(0)

        xhr :post, :create, { variant_id: variant.id, quantity: 1 }
        expect(order.line_items.size).to eq(1)

        xhr :post, :create, { variant_id: variant.id, quantity: 1 }
        expect(order.line_items.size).to eq(2)

        xhr :post, :create, { variant_id: variant2.id, quantity: 1 }
        expect(order.line_items.size).to eq(3)
      end
    end

    describe 'add gift to cart via ajax' do
      let!(:gift)                      { create(:spree_product, name: 'Gift', price: 0) }
      let!(:gift_variant)              { create(:spree_variant, product_id: gift.id, sku: 'gift-Color:Casablanca') }

      context 'somehow, adds a gift to an empty cart' do

        it 'gift is not added to the cart' do
          expect(order.line_items.size).to eq(0)

          xhr :get, :check_gift_in_cart
          expect(response.body).to eq ("{\"has_gift\":false}")

          xhr :post, :create, { gift_sku: 'gift-Color:Casablanca' }
          xhr :get, :check_gift_in_cart
          expect(response.body).to eq ("{\"has_gift\":false}")
          expect(order.line_items.size).to eq(0)
        end
      end

      context 'adds a gift to a non empty cart' do
        let!(:order)                   { create(:complete_order_with_items) }

        it 'adds gift to the cart' do
          expect(order.line_items.size).to eq(1)

          xhr :get, :check_gift_in_cart
          expect(response.body).to eq ("{\"has_gift\":false}")

          xhr :post, :create, { gift_sku: 'gift-Color:Casablanca' }
          xhr :get, :check_gift_in_cart
          expect(response.body).to eq ("{\"has_gift\":true}")
          expect(order.line_items.size).to eq(2)
        end
      end
    end
  end
end
