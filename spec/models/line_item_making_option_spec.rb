require 'spec_helper'

describe LineItemMakingOption do
  context "#build_option" do
    let(:product_option) { build(:product_making_option) }

    it "accepts product option and works" do
      expect(
        LineItemMakingOption.build_option(product_option, 'AUD')
      ).not_to be_blank
    end

    it "passes product option attributes" do
      option = LineItemMakingOption.build_option(product_option, 'AUD')

      expect(option.currency).to  eq('AUD')
      expect(option.flat_price).to eq(15.0)
      expect(option.making_option_id).to     eq(product_option.id)
    end
  end
end
