require 'spec_helper'

describe Spree::Product, :type => :model do
  let(:product) { described_class.new }

  context '#tags' do
    it 'contains array of tags' do
      expect(product.tags).to eq([])
    end
  end
end
