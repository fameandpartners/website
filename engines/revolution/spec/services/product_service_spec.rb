require 'spec_helper'

describe Revolution::ProductService do

  let(:product_ids)  {
    ["471-coral", "680-light-pink", "683-burgundy", "262-white", "704-black", "504-lavender", "680-forest-green"]
  }
  let(:service)     { described_class.new(product_ids, 'au') }

  it 'should parse the ids' do
    expect(service.ids).to eq ["471", "680", "683", "262", "704", "504", "680"]
  end

  it 'should parse the colours' do
    expect(service.colours).to eq ["coral", "light-pink", "burgundy", "white", "black", "lavender", "forest-green"]
  end
end
