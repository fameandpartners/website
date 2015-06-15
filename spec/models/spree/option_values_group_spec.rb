require 'spec_helper'

describe Spree::OptionValuesGroup, type: :model do
  it { is_expected.to belong_to(:option_type).class_name('Spree::OptionType') }
  it { is_expected.to have_and_belong_to_many(:option_values).class_name('Spree::OptionValue') }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:presentation) }
  it { is_expected.to validate_presence_of(:option_type) }

  describe 'scopes' do
    describe '.for_colors' do
      it 'returns only groups that belongs to the dresses-color OptionType' do
        color_option_type = create(:option_type, :color)
        other_option_type = create(:option_type)

        red   = create(:option_values_group, name: 'Red'  , option_type: color_option_type)
        blue  = create(:option_values_group, name: 'Blue' , option_type: color_option_type)
        jeans = create(:option_values_group, name: 'Jeans', option_type: other_option_type)

        result = described_class.for_colors
        expect(result).to match_array([red, blue])
      end
    end

    describe '.available_as_taxon' do
      it 'return only groups that are available as taxon' do
        available_group   = create(:option_values_group, available_as_taxon: true)
        unavailable_group = create(:option_values_group, available_as_taxon: false)

        result = described_class.available_as_taxon
        expect(result).to match_array([available_group])
      end
    end
  end
end