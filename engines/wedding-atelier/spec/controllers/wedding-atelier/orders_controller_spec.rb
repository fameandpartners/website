require 'spec_helper'

describe WeddingAtelier::OrdersController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:order) { create(:spree_order) }
  let(:product) { create(:dress) }
  let(:event) { create(:wedding_atelier_event) }
  let(:dress) { create(:wedding_atelier_event_dress, event: event, product: product) }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar') }
  let(:line_item_personalization) { LineItemPersonalization.new }

  before do
    custom_sign_in user
    allow(controller).to receive(:current_order).and_return(order)
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

  describe '#create' do
    let(:height1) { WeddingAtelier::Height.definitions[:petite].first }
    let(:height2) { WeddingAtelier::Height.definitions[:tall].first }
    context 'when sending an array of profiles with size and height' do
      let(:profiles) do
        {
          '0': {dress_size_id: 99, height: height1},
          '1': {dress_size_id: 100, height: height2}
        }
      end
      it 'adds a new line item to the cart' do
        xhr :post, :create, {dress_id: dress.id, profiles: profiles}
        expect(order.line_items.size).to eq(2)
        expect(response.status).to eq 200
      end
    end
    context 'when sending an array of profiles ' do
      let!(:profile) { user.create_user_profile(dress_size_id: 100, height: "4'11\"/150cm") }
      let(:profiles) do
        {
          '0': {id: user.id}
        }
      end
      it 'adds a new line item to the cart' do
        xhr :post, :create, {dress_id: dress.id, profiles: profiles}
        expect(order.line_items.size).to eq(1)
        expect(response.status).to eq 200
      end
    end
  end
end

