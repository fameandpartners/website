require 'spec_helper'

describe Repositories::LineItemImages do
  let!(:product) { FactoryGirl.create(:dress) }
  let!(:line_item) { FactoryGirl.build(:line_item, variant: product.master) }

  subject(:repository) { described_class.new(line_item: line_item) }

  describe '#read' do
    context 'given a line item' do
      # Repositories::ProductImages should be tested elsewhere
      let(:product_image_repository_double) { instance_double(Repositories::ProductImages) }

      before(:each) do
        expect(Repositories::ProductImages).to receive(:new).with(product: product).and_return(product_image_repository_double)
        expect(product_image_repository_double).to receive(:read).with(color_id: 123, cropped: true, product_customizations: nil, fabric: nil).and_return({})
      end

      it 'returns its product image' do
        result = repository.read(color_id: 123, cropped: true)
        expect(result).to be_an_instance_of(Repositories::Images::Template)
      end
    end

    context 'given a line item from the wedding atelier app' do
      # Image formation for wedding atelier dresses should be tested elsewhere, thus stubbing it
      # TODO: write specs for wedding atelier image formation given a line item without mocking it

      let!(:wedding_taxonomy) { FactoryGirl.create(:taxonomy, name: 'Wedding Atelier') }
      let!(:wedding_taxon) { wedding_taxonomy.root }

      before(:each) { product.taxons = [wedding_taxon] }

      it 'returns' do
        expect(repository).to receive(:image_for_wedding_atelier).and_return({})
        expect(repository.read).to be_an_instance_of(Repositories::Images::Template)
      end
    end
  end
end
