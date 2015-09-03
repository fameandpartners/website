require 'spec_helper'

describe Repositories::ProductColors, memoization_support: true do
  let(:color_option_type) { Spree::OptionType.color || create(:option_type, :color) }

  describe '.get_group_by_name' do
    it 'finds color group by name' do
      color_group = create(:option_values_group, option_type: color_option_type, name: 'Red')
      rememoize(Repositories::ProductColors, :@color_groups) 

      result = described_class.get_group_by_name('ReD')
      expect(result.id).to eq(color_group.id)
    end

    it 'does not find inexistent color group' do
      rememoize(Repositories::ProductColors, :@color_groups) 
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
