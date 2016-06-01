RSpec.shared_context 'return item ready to process' do
  let!(:global_sku) { create(:global_sku, id: 10001, sku: 'SKU-VERIFY', color_name: 'Red', size: 'AU 4/US 0', style_number: 'ABC123') }
  let(:variant) { build(:dress_variant, sku: 'SKU-VERIFY') }
  let(:line_item) { build(:line_item, variant: variant, price: 123.45) }
  let(:order) { create(:complete_order_with_items, line_items: [line_item]) }

  let(:order_return_request) { create(:order_return_request, order: order) }
  let(:return_request_item) { create(:return_request_item, :return, order_return_request: order_return_request, line_item: line_item) }
  let(:item_return) { return_request_item.item_return }

  let(:return_item_process) { Bergen::Operations::ReturnItemProcess.create(return_request_item: return_request_item) }

  before(:each) do
    allow(Bergen::Operations::ReturnItemProcess).to receive(:find).with(return_item_process.id).and_return(return_item_process)

    # Because of ActiveRecord ReeturnRequetItem#after_create callback #push_return_event, `ItemReturn`s are created on the fly
    item_return.bergen_asn_number = 'WHRTN1044588'
    item_return.save
  end
end
