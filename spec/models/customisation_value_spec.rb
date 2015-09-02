require 'spec_helper'

describe CustomisationValue, :type => :model do
  context "price" do
    let(:customization) { build(:customisation_value, price: 9.99) }

    it 'returns store price' do
      expect(customization.price).to eql(BigDecimal.new('9.99')) 
    end
  end

  context "#display_price" do
    let(:discount)      { double('discount', amount: 50, size: 50) }
    let(:customization) { build(:customisation_value, price: BigDecimal.new(100)) }

    it "returns price" do
      expect(customization.display_price.to_s).to eq('$100.00')
    end

    it "returns discounted price" do
      allow(customization).to receive(:discount).and_return(discount)
      expect(customization.display_price.to_s).to eq('$50.00')
    end
  end
end
