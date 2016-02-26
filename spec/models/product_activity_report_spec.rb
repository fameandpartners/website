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

  describe '#stats_list_to_hash' do
    include ProductActivityReport

    it do
      input    = '(viewed,24)|(added_to_cart,18)|(purchased,0)|(added_to_wishlist,27)'
      expected = {'viewed' => 24, 'added_to_cart' => 18, 'purchased' => 0, 'added_to_wishlist' => 27}

      expect(stats_list_to_hash(input)).to eq(expected)
    end

    it do
      input    = '(added_to_cart,48)|(purchased,0)'
      expected = {'added_to_cart' => 48, 'purchased' => 0}

      expect(stats_list_to_hash(input)).to eq(expected)
    end

    describe 'safe defaults of zero' do
      it 'for missing keys' do
        stats_list = stats_list_to_hash('(added_to_cart,48)|(purchased,0)')

        expect(stats_list['undefined_key']).to eq 0
      end

      it 'for bad inputs' do
        stats_list = stats_list_to_hash(nil)

        expect(stats_list['undefined_key']).to eq 0
      end
    end
  end
end
