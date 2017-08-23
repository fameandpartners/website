require 'spec_helper'

module Orders
  RSpec.describe LineItemCsvGenerator do
    let(:orders) { FactoryGirl.create_list(:complete_order_with_items, 3) }

    let(:csv_header) do
      [
        "order_state ",
        "order_number (订单号码)",
        "line_item ",
        "total_items ",
        "completed_at (订单日期)",
        "express_making (快速决策)",
        "projected_delivery_date (要求出厂日期)",
        "tracking_number (速递单号)",
        "shipment_date ",
        "fabrication_state ",
        "style (款号)",
        "style_name ",
        "factory (工厂)",
        "color (颜色)",
        "size (尺寸)",
        "height ",
        "customisations (特殊要求)",
        "custom_color ",
        "promo_codes ",
        "email ",
        "customer_notes ",
        "customer_name (客人名字)",
        "customer_phone_number (客人电话)",
        "shipping_address (客人地址)",
        "return_request ",
        "return_action ",
        "return_details ",
        "price ",
        "currency ",
        "upc "
      ]
    end

    subject { described_class.new(orders) }

    describe '#to_csv' do
      xit 'returns csv' do
        allow(Spree::LineItem).to receive(:find) {orders.first}

        result_csv = subject.to_csv

        result = CSV.parse(result_csv)

        expect(result.count).to eq(4)
        expect(result.first).to eq(csv_header)
      end
    end
  end
end
