require 'spec_helper'

describe Spree::OptionValue, type: :model do
  describe 'scopes' do
    describe '.colors' do
      context 'No color option type created' do
        it 'returns empty relation if no color option type' do
          expect(described_class.colors).to be_empty
        end
      end

      context 'Color option type created' do
        let!(:color_option_type) { create(:option_type, :color) }
        let!(:color_option_value) { create(:option_value, presentation: 'foo-red', name: 'foo-red', option_type: color_option_type) }

        it 'returns options values for color option type' do
          expect(described_class.colors).to eq([color_option_value])
        end
      end
    end

    describe '.sizes' do
      context 'No size option type created' do
        it 'returns empty relation if no size option type' do
          expect(described_class.sizes).to be_empty
        end
      end

      context 'Size option type created' do
        let!(:size_option_type) { create(:option_type, :size) }
        let!(:size_option_value) { create(:option_value, name: 'foo-size', presentation: 'foo-size', option_type: size_option_type) }

        it 'returns options values for size option type' do
          expect(described_class.sizes).to eq([size_option_value])
        end
      end
    end
  end
end
