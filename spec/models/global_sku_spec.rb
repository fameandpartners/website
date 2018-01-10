require 'rails_helper'
require 'pry-byebug'

RSpec.describe GlobalSku, type: :model do
  it { is_expected.to belong_to(:product).class_name('Spree::Product') }
  it { is_expected.to belong_to(:variant).class_name('Spree::Variant') }

  describe 'aliased methods' do
    let(:instance) { build(:global_sku, id: 123) }

    it { expect(instance.id).to eq (instance.upc) }
  end

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
      let!(:size_option_value) { FactoryGirl.create(:product_size, name: 'US0/AU4', presentation: 'US 0/AU 4') }
      let!(:color_option_value) { FactoryGirl.create(:product_colour, name: 'charpinkle') }

      let!(:cut_customisation_value) { FactoryGirl.create(:customisation_value, :cut) }
      let!(:fit_customisation_value) { FactoryGirl.create(:customisation_value, :fit) }

      let!(:line_item_personalization) { FactoryGirl.build(:personalization,
                                                            color:                   color_option_value,
                                                            size:                    size_option_value,
                                                            customization_value_ids: [cut_customisation_value.id, fit_customisation_value.id]
      ) }

      let(:style_number)  { 'FB1000' }
      let(:customization_ids) { [cut_customisation_value.id, fit_customisation_value.id] }
      let(:dress)         { create :dress_with_magenta_size_10, sku: style_number, customisation_value_ids: customization_ids }
      let(:master)        { dress.master }
      let(:variant)       { dress.variants.first }
      let(:item) { build :line_item, variant: variant, customizations: [cut_customisation_value, fit_customisation_value].to_json }

      let(:line_item) {
        instance_spy('Orders::LineItemPresenter',
                     sku:             'I Do Not Exist',
                     style_number:    'BAE12345',
                     style_name:      'Cool Bae',
                     size:            'US0/AU4',
                     colour_name:     'Charpinkle',
                     height:          'Petite',
                     personalization: line_item_personalization,
                     item:            item
                     
        )
      }

      it do
        created = GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item)

        expect(created).to be_an_instance_of(GlobalSku)
        expect(created.persisted?).to eq(true)
      end
    end
  end
end
