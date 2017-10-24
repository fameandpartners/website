require 'spec_helper'

describe NextLogistics::FTP::Receipt do
  describe '#tempfile' do
    context 'given a return request process with return request items' do
      let(:dress_size) { build(:product_size, name: 'US10/AU14') }
      let(:dress_color) { build(:product_colour, name: 'Yellow') }

      let!(:global_sku) { create(:global_sku, id: 10001, style_number: 'ABC123', sku: 'SKU-VERIFY') }
      let(:product) { create(:dress, name: 'Stylight') }
      let(:variant) { build(:dress_variant, sku: 'SKU-VERIFY', product: product, option_values: [dress_size, dress_color]) }
      let(:line_item) { build(:line_item, variant: variant) }
      let(:order) do
        create(:complete_order_with_items, number: 'R987654321', line_items: [line_item],
                                           user_first_name: 'Mariah', user_last_name: 'Silvester')
      end

      let(:order_return_request) { create(:order_return_request, order: order) }
      let!(:return_request_item_to_keep) do
        create(:return_request_item, :keep, order_return_request: order_return_request, line_item: line_item)
      end
      let!(:return_request_item_to_return) do
        create(:return_request_item, :return, order_return_request: order_return_request, line_item: line_item)
      end

      let(:return_request_process) do
        NextLogistics::ReturnRequestProcess.create(order_return_request: order_return_request)
      end

      it 'generates a formatted CSV with items for return' do
        receipt  = described_class.new(return_request_process: return_request_process)
        tempfile = receipt.tempfile

        tempfile.rewind
        expect(tempfile.read).to eq <<~STRING
          Reference1,Reference2,Reference3,ProductCode,Quantity,Description,ProductType,ImageLink,SupplierCode
          R987654321,Mariah Silvester,"",10001,1,Stylight - US10/AU14 - Yellow,"","",ABC123
        STRING
      end
    end
  end
end
