require 'spec_helper'

RSpec.describe MailChimp::Product, type: :model do

  let(:product) { double('Product', sku: 'SKU', name: 'Name') }
  let(:master) { double('Master Variant', sku: 'SKU') }

  before do
    allow(product).to receive(:master).and_return(master)
  end

  describe('::Exists', :vcr) do

    it('should check if product exists') do
      result = described_class::Exists.(product)
      expect(result).to eql(false)
    end
  end

  describe('::Create', :vcr) do

    it('should create customer') do
      result = described_class::Create.(product)
      expect(result).to eql(true)
    end
  end
end
