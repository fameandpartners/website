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

    it { is_expected.to validate_inclusion_of(:customisation_type).in_array(described_class::AVAILABLE_CUSTOMISATION_TYPES) }
  end

  describe 'scopes' do
    describe 'for its available customisation types' do
      shared_examples 'has a customisation type scope for' do |customisation_type_symbol|
        let!(:customisation_type) { FactoryGirl.create(:customisation_value, customisation_type_symbol) }
        subject { described_class.by_type(customisation_type_symbol) }

        it { is_expected.to contain_exactly(customisation_type) }
      end

      it_behaves_like 'has a customisation type scope for', :cut
      it_behaves_like 'has a customisation type scope for', :fabric
      it_behaves_like 'has a customisation type scope for', :length
      it_behaves_like 'has a customisation type scope for', :fit
      it_behaves_like 'has a customisation type scope for', :style
    end
  end

  context "price" do
    let(:customization) { build(:customisation_value, price: 9.99) }

    it 'returns store price' do
      expect(customization.price).to eql(BigDecimal.new('9.99'))
    end
  end
end
