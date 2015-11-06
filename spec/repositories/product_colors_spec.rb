require 'spec_helper'

describe Repositories::ProductColors, memoization_support: true do
  let!(:color_option_type) { create(:option_type, :color) }

  # Invalidating memoizations that concern Repositories::ProductColors
  before(:each) do
    rememoize(Spree::OptionType, :@color)
    rememoize(Repositories::ProductColors, :@color_groups)
  end

  describe '.get_group_by_name' do
    let!(:color_group) { create(:option_values_group, option_type: color_option_type, name: 'Red') }

    it 'finds color group by name' do
      result = described_class.get_group_by_name('ReD')
      expect(result.id).to eq(color_group.id)
    end

    it 'does not find inexistent color group' do
      result = described_class.get_group_by_name('Nothing Here')
      expect(result).to be_nil
    end

    context 'given a blank name' do
      it 'returns nil' do
        result = described_class.get_group_by_name('')
        expect(result).to be_nil
      end
    end
  end
end
