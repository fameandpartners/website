require 'spec_helper'

describe ProductActivityReport, type: :feature do
  describe '.total_product_viewed' do
    let(:viewed_product)    { create(:dress, id: 777) }
    let(:unviewed_product)  { create(:dress, id: 989) }


    subject(:views_for_report_product) {
      ProductActivityReport.total_product_viewed(report_product.id)
    }

    before do
      20.times do
        Activity.log_product_viewed(viewed_product)
      end
    end

    context 'a viewed product' do
      let(:report_product) { viewed_product }

      it '20 times' do
        expect(views_for_report_product).to eq 20
      end
    end

    context 'non viewed product' do
      let(:report_product) { unviewed_product }

      it 'has 0 views' do
        expect(views_for_report_product).to eq 0
      end
    end

    describe '.all_actions' do
      it do
        expected_actions = {777 => {"viewed" => 20 }}

        expect(ProductActivityReport.all_actions).to eq(expected_actions)
      end
    end
  end
end
