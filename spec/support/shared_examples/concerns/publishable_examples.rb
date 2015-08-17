RSpec.shared_examples 'publishable class' do |klass_symbol|
  describe 'scopes' do
    describe '.published' do
      let!(:unpublished_object) { create(klass_symbol, published_at: 2.days.from_now) }
      let!(:published_object)   { create(klass_symbol, published_at: 1.day.ago) }

      it 'returns published objects' do
        result = described_class.published
        expect(result).to match([published_object])
      end
    end

    describe '#publish!' do
      let!(:unpublished_object) { create(klass_symbol, published_at: 2.days.from_now) }

      it 'updates the published_at attribute to now' do
        Timecop.freeze do
          unpublished_object.publish!
          expect(unpublished_object.updated_at).to eq(Time.zone.now)
        end
      end
    end
  end
end
