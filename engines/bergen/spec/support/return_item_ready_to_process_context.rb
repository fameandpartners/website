RSpec.shared_context 'return item ready to process' do
  let(:country) { build(:country, name: 'United States of America') }
  let(:state) { build(:state, name: 'California', country: country) }
  let(:ship_address) { build(:address, address1: 'Street 1', address2: 'Complement', zipcode: '123-321', city: 'Los Angeles', state: state) }

  let(:dress_size) { build(:product_size, name: 'US10/AU14') }
  let(:dress_color) { build(:product_colour, name: 'Blue') }

  let!(:global_sku) { create(:global_sku, id: 10001, sku: 'SKU-VERIFY', color_name: 'Red', size: 'AU 4/US 0', style_number: 'ABC123', height_value: 'petite', customisation_name: 'Super Custom') }
  let(:product) { create(:dress, name: 'Stylight', sku: 'product-sku') }
  let(:variant) { build(:dress_variant, sku: 'SKU-VERIFY', product: product, option_values: [dress_size, dress_color]) }
  let(:line_item) { build(:line_item, variant: variant, price: 123.45) }
  let(:order) { create(:complete_order_with_items, number: 'R123123', ship_address: ship_address, completed_at: '10/10/2015 12:34:00 UTC', line_items: [line_item]) }

  let(:order_return_request) { create(:order_return_request, order: order) }
  let(:return_request_item) { create(:return_request_item, :return, order_return_request: order_return_request, line_item: line_item) }
  let(:item_return) { return_request_item.item_return }

  let(:return_item_process) { Bergen::Operations::ReturnItemProcess.create(return_request_item: return_request_item) }

  before(:each) do
    allow(Bergen::Operations::ReturnItemProcess).to receive(:find).with(return_item_process.id).and_return(return_item_process)

    # Because of ActiveRecord ReeturnRequetItem#after_create callback #push_return_event, `ItemReturn`s are created on the fly
    item_return.bergen_asn_number   = 'WHRTN1044588'

    # Payment amounts are too coupled with completed Spree Payments, which won't work with current factories
    item_return.order_paid_currency = 'AUD'
    item_return.save
  end
end
