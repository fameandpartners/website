require 'spec_helper'

describe Preferences::ShoppingBag, type: :presenter, spree_config_support: true do
  let(:spree_config) { Spree::AppConfiguration.new }
  let(:site_version) { build_stubbed(:site_version, permalink: 'au') }
  let(:shopping_bag) { described_class.new(site_version) }

  describe '#value_proposition_key' do
    it 'returns the value proposition preference key' do
      expect(shopping_bag.value_proposition_key).to eq('au_value_proposition_key')
    end
  end

  describe '#value_proposition' do
    it 'returns the value proposition preference value' do
      define_spree_config_preference(:au_value_proposition_key, 'Value Proposition', :string)
      expect(shopping_bag.value_proposition).to eq('Value Proposition')
    end
  end

  describe '#shipping_message_key' do
    it 'returns the shipping message preference key' do
      expect(shopping_bag.shipping_message_key).to eq('au_shipping_message_key')
    end
  end

  describe '#shipping_message' do
    it 'returns the shipping message preference value' do
      define_spree_config_preference(:au_shipping_message_key, 'Shipping Message', :string)
      expect(shopping_bag.shipping_message).to eq('Shipping Message')
    end
  end
end
