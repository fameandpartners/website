require 'spec_helper'

describe LineItemMakingOption do
  it "exists" do
    expect(LineItemMakingOption.new).not_to be_blank
  end

  context "#build_option" do
    let(:product_option) { build(:product_making_option) }

    it "accepts product option and works" do
      expect(
        LineItemMakingOption.build_option(product_option, 'AUD')
      ).not_to be_blank
    end

    it "passes product option attributes" do
      product_option.assign_attributes({
        price: BigDecimal.new(rand(100)),
        currency: "CUR"
      }, { without_protection: true })
      option = LineItemMakingOption.build_option(product_option, 'AUD')

      expect(option.price).to     eq(product_option.price)
      expect(option.currency).to  eq(product_option.currency)
    end
  end
end
