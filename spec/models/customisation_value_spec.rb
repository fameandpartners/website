require 'spec_helper'

describe CustomisationValue, :type => :model do
  context "price" do
    let(:customization) { build(:customisation_value, price: 9.99) }

    it 'returns store price' do
      expect(customization.price).to eql(BigDecimal.new('9.99')) 
    end
  end
end
