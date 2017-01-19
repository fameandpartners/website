require 'spec_helper'

describe CustomisationValue, :type => :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:presentation) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_presence_of(:customisation_type) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:product_id) }
    it { is_expected.to validate_uniqueness_of(:presentation).scoped_to(:product_id) }
    it { is_expected.to validate_uniqueness_of(:position).scoped_to(:product_id) }

    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:position).only_integer }

    it { is_expected.to validate_inclusion_of(:customisation_type).in_array(described_class::AVAILABLE_TYPES) }
  end

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
