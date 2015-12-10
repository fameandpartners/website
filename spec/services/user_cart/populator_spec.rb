require 'spec_helper'

module UserCart
  RSpec.describe Populator do
    describe '#custom_height?' do
      it 'not custom by default' do
        populator = described_class.new

        expect(populator.send(:custom_height?)).to be_falsey
      end

      it 'not custom when standard height' do
        populator = described_class.new(product: { height: 'standard' })

        expect(populator.send(:custom_height?)).to be_falsey
      end

      it 'is custom when any other height' do
        non_standard_heights = %w(foo bar baz petite tall venti grande)
        populator = described_class.new(product: { height: non_standard_heights.sample })

        expect(populator.send(:custom_height?)).to be_truthy
      end
    end
  end
end
