require 'spec_helper'

describe Products::ProductsFilter do
  describe 'class methods' do
    describe '.available_sort_orders' do
      it do
        result = described_class.available_sort_orders
        expect(result).to eq([
                               ['price_high', 'Price High'],
                               ['price_low', 'Price Low'],
                               ['newest', "What's new"],
                             ])
      end
    end
  end
end
