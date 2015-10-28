require 'spec_helper'

describe Revolution::ProductService do

  let(:product_ids)  {
    ["471-coral", "680-light-pink", "683-burgundy", "262-white", "704-black", "504-lavender", "680-forest-green"]
  }
  let(:fake_image) do
    OpenStruct.new(
        position: 1,
        original: 'http://images.fameandpartners.com/original.png',
        large:    'http://images.fameandpartners.com/large.png',
        xlarge:   'http://images.fameandpartners.com/xlarge.png',
        small:    'http://images.fameandpartners.com/small.png',
        color:    'coral',
        color_id: 29
    )
  end
  let(:product_images) { [fake_image] }
  let!(:dress) { create(:dress, id: 471) }
  let(:service)     { described_class.new(product_ids, 'au') }
  let!(:current_site_version) { create(:site_version) }
  let(:params) { { controller:"products/collections", action:"show", permalink:"formal", limit: 21 } }
  subject!(:page) { Revolution::Page.create!(path: '/dresses/formal') }

  it 'should parse the ids' do
    expect(service.ids).to eq ["471", "680", "683", "262", "704", "504", "680"]
  end

  it 'should parse the colours' do
    expect(service.colours).to eq ["coral", "light-pink", "burgundy", "white", "black", "lavender", "forest-green"]
  end

  describe '.products' do
    it 'given an offset greater than the number of products o products are returned' do
      page.variables = { pids: product_ids }
      params[:offset] = 8
      expect(Revolution::ProductService.new(service.ids, current_site_version).products(params, 7).size).to be nil
    end

    it 'something' do
      page.variables = { pids: product_ids }
      p dress
      p double(Spree::Image)
      expect(Revolution::ProductService.new(service.ids, current_site_version).products(params, 7).size).to be nil
    end
  end
end
