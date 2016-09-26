require 'spec_helper'

RSpec.describe MailChimp::Variant, type: :model do

  let(:product) { double('Product', sku: 'SKU', name: 'Name') }
  let(:variant_sku) { 'VariantSKU' }

  describe('::Exists', :vcr) do

    it('should check if variant exists') do
      result = described_class::Exists.(product, variant_sku)
      expect(result).to eql(false)
    end
  end

  describe('::Create', :vcr) do

    it('should create variant') do
      result = described_class::Create.(product, variant_sku)
      expect(result).to eql(true)
    end
  end
end
