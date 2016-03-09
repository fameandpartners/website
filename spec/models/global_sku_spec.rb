require 'rails_helper'

RSpec.describe GlobalSku, :type => :model do

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of :sku }
  end

  describe '.find_or_create_by_line_item' do
    context 'existing sku' do
      let(:known_sku) { create(:global_sku) }

      let(:line_item) { instance_spy('Orders::LineItemPresenter', sku: known_sku.sku) }
      it do
        found = GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item )

        expect(found).to eq known_sku
      end
    end

    context 'creates a new sku' do
      let(:fresh_sku) { Faker.bothify("???####US##AU##C#X#H?").upcase }

      let(:line_item) { instance_spy('Orders::LineItemPresenter',
                                     sku:                 fresh_sku,
                                     style_number:        'BAE12345',
                                     style_name:          'Cool Bae',
                                     size:                'USUSAUAU',
                                     colour_id:           89,
                                     colour_name:         'Charpinkle',
                                     height:              'X',
                                     product_id:          44,
                                     variant_id:          999,
                                     customisation_ids:   [4],
                                     customisation_names: %w(IncreaseMagic))
      }

      it do
        created = GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item)

        expect(created.sku).to eq fresh_sku
        expect(created.style_number).to eq 'BAE12345'
      end
    end
  end
end
