require 'spec_helper'

module Orders
  RSpec.describe LineItemCSVPresenter do
    let(:order) { FactoryGirl.create(:complete_order_with_items) }
    let(:line) { order.attributes }

    # the same as UPC
    describe '::product_number' do
      # TODO: we should define which GlobalSku is used
      it "gets id from global_sku" do
        described_class.set_line(line)

        expect(described_class.product_number).to eq(GlobalSku.last.id)
      end
    end
  end
end
