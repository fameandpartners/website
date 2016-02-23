require 'spec_helper'

describe ProductActivityReport, type: :feature do
  describe '.total_product_viewed' do
    let(:viewed_product)    { create(:dress, id: 777) }
    let(:unviewed_product)  { create(:dress, id: 989) }


    subject(:views_for_report_product) {
      ProductActivityReport.total_product_viewed(report_product.id)
    }

    before do
      100.times do
        Activity.log_product_viewed(viewed_product)
      end
    end

    context 'a viewed product' do
      let(:report_product) { viewed_product }

      it '100 times' do
        expect(views_for_report_product).to eq 100
      end
    end

    context 'non viewed product' do
      let(:report_product) { unviewed_product }

      it 'has 0 views' do
        expect(views_for_report_product).to eq 0
      end
    end
  end
end
