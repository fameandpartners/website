require 'spec_helper'

describe Forms::ManualOrderFilter do
  let(:product) { FactoryGirl.create(:spree_product) }
  let(:filter) { described_class.new(product_id: product.id) }

  describe '#height_options' do
    let(:three_heights) do
      [
        {id: "petite", name: "Petite"},
        {id: "standard", name: "Standard"},
        {id: "tall", name: "Tall"}
      ]
    end

    let(:six_heights) do
      [
        {id: "length1", name: "Length1 (4'10\"-5'1\") or (148-156cm)"},
        {id: "length2", name: "Length2 (5'2\"-5'4\") or (157-164cm)"},
        {id: "length3", name: "Length3 (5'5\"-5'7\") or (165-172cm)"},
        {id: "length4", name: "Length4 (5'8\"-5'10\") or (173-179cm)"},
        {id: "length5", name: "Length5 (5'11\"-6'1\") or (180-186cm)"},
        {id: "length6", name: "Length6 (6'2\"-6'4\") or (187-193cm)"}
      ]
    end

    it 'returns 3 heights for legacy products' do
      expect(filter.heights_options).to eq(three_heights)
    end

    it 'returns 3 heights if master range group has 3 heights' do
      group = ProductHeightRangeGroup.create(name: 'three_sizes')
      StyleToProductHeightRangeGroup.create(product_height_range_group_id: group.id, style_number: product.sku)

      expect(filter.heights_options).to eq(three_heights)
    end

    it 'returns 6 heights if master range group has 6 heights' do
      group = ProductHeightRangeGroup.create(name: 'six_sizes')
      StyleToProductHeightRangeGroup.create(product_height_range_group_id: group.id, style_number: product.sku)

      expect(filter.heights_options).to eq(six_heights)
    end
  end
end
