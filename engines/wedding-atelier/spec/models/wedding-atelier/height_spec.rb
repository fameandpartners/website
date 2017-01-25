require 'spec_helper'

describe WeddingAtelier::Height do
  describe '.height_group' do
    context 'when trying to map a height in detail to group' do
      it 'returns a string' do
        expect(WeddingAtelier::Height.height_group("6'5\"/196cm")).to eql('tall')
        expect(WeddingAtelier::Height.height_group("6'5\"/196cm")).not_to eql(:tall)
      end
    end
  end
end
