require 'spec_helper'

describe Preferences::Base, spree_config_support: true do
  let(:base) { described_class.new('Site Version') }

  describe '#preference_value' do
    context 'given a spree preference key' do
      context 'spree config does not exist' do
        it 'returns nil' do
          result = base.preference_value('something')
          expect(result).to be_nil
        end
      end

      context 'spree config exists' do
        it 'returns its value' do
          define_spree_config_preference('spree_preference_key', 'My Super Value', :string)
          result = base.preference_value('spree_preference_key')
          expect(result).to eq('My Super Value')
        end
      end
    end
  end
end
