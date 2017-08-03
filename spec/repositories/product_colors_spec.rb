require 'spec_helper'

xdescribe Repositories::ProductColors do
  let!(:color_option_type) { create(:option_type, :color) }

  describe '.get_group_by_name' do
    let!(:color_group) { create(:option_values_group, :with_option_value, option_type: color_option_type, name: 'Red') }

    it 'finds color group by name' do
      result = described_class.get_group_by_name('ReD')
      expect(result[:id]).to eq(color_group[:id])
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

  describe '.get_color_by_name' do
    let!(:color_group) { create(:option_values_group, :with_option_value, option_type: color_option_type, name: 'blue') }

    it 'finds a color by name' do
      name = 'blue'
      result = described_class.get_by_name(name)
      expect(result[:name]).to eq(name)
    end
  end
end
