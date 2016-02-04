require 'spec_helper'

RSpec.describe SimpleKeyValue, :type => :model do
  it do
    SimpleKeyValue.set :foo, "bar"

    expect(SimpleKeyValue.get(:foo)).to eq "bar"
  end

  it do
    SimpleKeyValue.set :foo, "bar"
    SimpleKeyValue.set :foo, "baz"

    expect(SimpleKeyValue.get(:foo)).to eq "baz"
  end
end

RSpec.describe SimpleKeyValue::FeatureMigration do
  describe '.remove_feature' do
    before do
      Features.activate(:feature_to_be_removed)
    end

    describe 'Features.activate ensures the feature exists' do
      it do
        expect(SimpleKeyValue.get('feature:feature_to_be_removed')).to eq '100||'
      end
    end

    describe 'deleting the feature removes it' do
      it do
        SimpleKeyValue::FeatureMigration.remove_feature(:feature_to_be_removed)

        expect(Features.active?(:feature_to_be_removed)).to be_falsey
      end
    end
  end

  describe '.drop_item_from_list' do
    let(:list)   { "a,b,c,d" }
    let(:remove) { "d" }

    subject(:result) { described_class.drop_item_from_list(list, remove) }

    it 'removed the item' do
      is_expected.to eq 'a,b,c'
    end

    context 'non existent elements' do
      let(:remove) { "x" }
      it 'is a no-op' do
        is_expected.to eq list
      end
    end
  end
end
