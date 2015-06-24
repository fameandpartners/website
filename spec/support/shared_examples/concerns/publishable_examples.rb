RSpec.shared_examples 'publishable class' do |klass_symbol|
  describe 'scopes' do
    describe '.published' do
      let!(:unpublished_onject) { create(klass_symbol, published_at: 2.days.from_now) }
      let!(:published_object)   { create(klass_symbol, published_at: 1.day.ago) }

      it 'returns published objects' do
        result = described_class.published
        expect(result).to match([published_object])
      end
    end
  end
end
