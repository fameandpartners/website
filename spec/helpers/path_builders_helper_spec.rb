require 'spec_helper'

describe PathBuildersHelper, :type => :helper do
  describe '#collection_product_path' do
    # TODO: Write some specs for other scenarios, like the product argument being a Tire::Results::Item

    let(:color_double) { double('Color', name: 'pastel') }
    let(:dress) { build_stubbed(:dress, id: 101, name: 'Super Dress') }

    context 'given a color in the options hash' do
      it 'returns the path of a product with the given color' do
        result = helper.collection_product_path(dress, { :color => 'burgundy' })
        expect(result).to eq('/dresses/dress-super-dress-101?color=burgundy')

        # Even if the product has a color
        allow(dress).to receive(:color).and_return(color_double)
        result = helper.collection_product_path(dress, { :color => 'black' })
        expect(result).to eq('/dresses/dress-super-dress-101?color=black')
      end
    end

    context 'given a product that responds to the color method' do
      # TODO: Product here should be a Tire::Results::Item
      before(:each) { allow(dress).to receive(:color).and_return(color_double) }

      it 'returns the path of a product with the product\'s color' do
        result = helper.collection_product_path(dress)
        expect(result).to eq('/dresses/dress-super-dress-101?color=pastel')
      end
    end
  end

  describe '#collection_jacket_path' do
    let(:jacket) { build_stubbed(:jacket, id: 101, name: 'Super Jacket') }

    context 'product has a color' do
      let(:color_double) { double('Color', name: 'pastel') }

      before(:each) { allow(jacket).to receive(:color).and_return(color_double) }

      it 'returns the path of a jacket with the given color' do
        result = helper.collection_jacket_path(jacket)
        expect(result).to eq('/jackets/jacket-super-jacket-101?color=pastel')
      end
    end

    it 'returns the path of a jacket' do
      result = helper.collection_jacket_path(jacket)
      expect(result).to eq('/jackets/jacket-super-jacket-101')
    end
  end

  describe '#build_url' do
    context 'given an array of strings as parts of a path' do
      it 'builds a path without a query string' do
        result = helper.build_url(['something', 'nice'])
        expect(result).to eq('/something/nice')
      end

      it 'builds path correctly even with empty elements' do
        result = helper.build_url(['', 'my-path'])
        expect(result).to eq('/my-path')
      end

      it 'builds root path' do
        result = helper.build_url([])
        expect(result).to eq('/')
      end
    end

    context 'given an array of strings as parts of a path and options for query strings' do
      it 'builds a complete path' do
        result = helper.build_url(['my', 'url', 'parts'], { :super => 'gigantic', :query => 'string' })
        expect(result).to eq('/my/url/parts?query=string&super=gigantic')
      end
    end
  end
end
