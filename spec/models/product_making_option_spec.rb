require 'spec_helper'

describe ProductMakingOption, type: :model do
  it { is_expected.to belong_to(:product).class_name('Spree::Product').touch(true) }
  it { is_expected.to belong_to(:variant).class_name('Spree::Variant') }

  it { is_expected.to validate_presence_of(:option_type) }
  it { is_expected.to validate_inclusion_of(:option_type).in_array(described_class::OPTION_TYPES) }
  it { is_expected.to validate_uniqueness_of(:option_type).scoped_to(:product_id) }

  it { is_expected.to validate_numericality_of(:price) }

  it { is_expected.to validate_inclusion_of(:currency).in_array(described_class::ALL_CURRENCIES) }

  context '#assign_default_attributes' do
    let(:subject) { described_class.new }

    it do
      subject.assign_default_attributes

      expect(subject.active).to eq(true)
      expect(subject.price).to eq(described_class::DEFAULT_OPTION_PRICE)
      expect(subject.currency).to eq(described_class::DEFAULT_CURRENCY)
    end
  end
end
