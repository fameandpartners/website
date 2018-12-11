require 'spec_helper'

describe 'user_cart/', type: :routing do

  context 'showing the cart' do
    let(:show_cart) { { controller: 'user_cart/details', action: 'show' } }

    it { expect(get: '/user_cart').to route_to(show_cart) }
    it { expect(get: '/user_cart/details').to route_to(show_cart) }
  end

  it 'accepting promo codes' do
    expect(post: '/user_cart/promotion')
      .to route_to(controller: 'user_cart/promotions', action: 'create')
  end

  it 'remove line items' do
    expect(delete: '/user_cart/products/77')
      .to route_to(controller: 'user_cart/products',
                   action:     'destroy',
                   line_item_id: '77')
  end
end
