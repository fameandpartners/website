require 'spec_helper'

describe ProductMakingOption, type: :model do
  it { is_expected.to validate_presence_of(:option_type) }
  it { is_expected.to validate_inclusion_of(:option_type).in_array(described_class::OPTION_TYPES) }
  it { is_expected.to validate_uniqueness_of(:option_type).scoped_to(:product_id) }

  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

  context '#assign_default_attributes' do
    let(:subject) { described_class.new }

    it 'set price' do
      subject.assign_default_attributes
      expect(subject.price).to eq(described_class::DEFAULT_OPTION_PRICE)
    end

    it 'sets currency' do
      expect(SiteVersion).to receive(:default).and_return(instance_double('sv', currency: 'USD'))
      subject.assign_default_attributes
      expect(subject.currency).to eq('USD')
    end
  end
end
