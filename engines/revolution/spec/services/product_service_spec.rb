require 'spec_helper'

describe Revolution::ProductService do
  let(:product_ids) { %w(471-coral 680-light-pink 683-burgundy 262-white 704-black 504-lavender 680-forest-green) }

  let!(:dress) { create(:dress, id: 471) }
  let(:service) { described_class.new(product_ids, 'au') }
  let!(:current_site_version) { build_stubbed(:site_version) }
  let(:params) { { controller: 'products/collections', action: 'show', permalink: 'formal', limit: 21 } }
  let(:limit) { 10 }
  let(:variables) { { pids: product_ids } }

  subject(:page) { Revolution::Page.create!(path: '/dresses/formal', variables: variables) }

  it 'should parse the ids' do
    expect(service.ids).to eq %w(471 680 683 262 704 504 680)
  end

  it 'should parse the colours' do
    expect(service.colours).to eq %w(coral light-pink burgundy white black lavender forest-green)
  end

  describe '#products' do
    context 'when limit is greater than the products' do
      let(:limit) { 7 }
      subject(:service) { Revolution::ProductService.new(product_ids, current_site_version) }

      it 'given an offset greater than the number of products 0 products are returned' do
        page.variables  = {pids: product_ids}
        params[:offset] = 8

        result = service.products(params, limit)
        expect(result).to eq([])
      end
    end

    context 'when there are nil items' do
      it 'remove all nil items' do
        allow_any_instance_of(Revolution::ProductService).to receive(:get_revolution_ids).and_return(["471",nil,nil,nil])
        expect(Revolution::ProductService.new(service.ids, current_site_version).products(params, limit).size).to be 1
      end
    end
  end

  describe '.id_end' do
    context 'given 7 products' do
      it 'returns position of 6 if limit > ids' do
        expect(service.id_end(params, limit)).to eq 6
      end

      it 'returns position of 6 if limit = ids' do
        limit = 7
        expect(service.id_end(params, limit)).to eq 6
      end

      it 'returns position of 5 if limit = 6' do
        limit = 6
        expect(service.id_end(params, limit)).to eq 5
      end

      it 'returns position of 0 if limit = 6 and offset = 6' do
        limit           = 6
        params[:offset] = 6
        expect(service.id_end(params, limit)).to eq 0
      end

      it 'returns position of -1 if limit = 7 and offset = 7' do
        limit           = 7
        params[:offset] = 7
        expect(service.id_end(params, limit)).to eq -1
      end
    end
  end

  describe '.get_revolution_ids' do
    context "given 7 products" do
      it 'returns 7 ids if limit > ids' do
        expect(service.get_revolution_ids(params, limit).size).to eq 7
      end

      it 'returns 7 ids if limit = ids' do
        limit = 7
        expect(service.get_revolution_ids(params, limit).size).to eq 7
      end

      it 'returns 6 ids if limit = 6' do
        limit = 6
        expect(service.get_revolution_ids(params, limit).size).to eq 6
      end

      it 'returns 1 ids if limit = 6 and offset = 6' do
        limit           = 6
        params[:offset] = 6
        expect(service.get_revolution_ids(params, limit).size).to eq 1
      end

      it 'returns 0 ids if limit = 7 and offset = 7' do
        limit           = 7
        params[:offset] = 7
        expect(service.get_revolution_ids(params, limit).size).to eq 0
      end
    end
  end
end
