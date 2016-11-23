require 'spec_helper'

module Orders
  RSpec.describe LineItemCSVPresenter do
    # the same as UPC
    describe '::product_number' do
      it "gets id from global_sku" do
        expect(described_class).to receive(:global_sku).and_return(double(:global_sku, id: 'test_upc'))

        expect(described_class.product_number).to eq('test_upc')
      end
    end
  end
end
