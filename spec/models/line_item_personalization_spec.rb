require 'spec_helper'

describe LineItemPersonalization, type: :model do
  context "price" do
    let(:personalization) { build(:personalization) }
    let(:line_item)       { build(:spree_line_item, price: 9.99) }
    let(:discount)        { OpenStruct.new(amount: 50, size: 50) }

    context "#size_cost" do
      it "returns 0 for default sizes" do
        expect(personalization).to receive(:add_plus_size_cost?).and_return(false)
        expect(personalization.size_cost).to eql(BigDecimal.new(0))
      end

      it "adds price for custom size" do
        expect(personalization).to receive(:add_plus_size_cost?).and_return(true)
        expect(personalization.size_cost).to eql(BigDecimal.new('20.0'))
      end
    end

    context "#color_cost" do
      it "works if no data" do
        expect(personalization.color_cost).to eql(BigDecimal.new(0))
      end

      it "returns 0 for basic color" do
        personalization.product = Spree::Product.new
        personalization.color = Spree::OptionValue.new
        expect(personalization).to receive(:basic_color?).and_return(true)

        expect(personalization.color_cost).to eql(BigDecimal.new(0))
      end

      it "adds price for custom color" do
        personalization.product = Spree::Product.new
        personalization.color = Spree::OptionValue.new
        expect(personalization).to receive(:basic_color?).and_return(false)

        expect(personalization.color_cost).to eql(BigDecimal.new('16.0'))
      end

      it "retuds discounted price for custom colour" do
        personalization.product = Spree::Product.new
        expect(personalization).to receive(:color).at_least(:once).and_return(
          double('Spree::OptionValue', discount: OpenStruct.new(amount: 50, size: 50))
        )
        expect(personalization).to receive(:basic_color?).and_return(false)

        expect(personalization.color_cost).to eql(BigDecimal.new('8.0'))
      end
    end

    context "#customizations_cost" do
      it "returns 0 if no customizations" do
        expect(personalization.customizations_cost).to eql(BigDecimal.new(0))
      end

      it "returns sum of prices" do
        expect(personalization).to receive(:customization_values).at_least(:once).and_return(
          Array.new(2) { build(:customisation_value, price: 15.0) }
        )
        expect(personalization.customizations_cost).to eql(BigDecimal.new('30.0'))
      end

      it "returns sum of discounted prices" do
        customization = build(:customisation_value, price: 15.0)
        expect(customization).to receive(:discount).and_return(discount)
        expect(personalization).to receive(:customization_values).and_return([customization])

        expect(personalization.customizations_cost).to eql(BigDecimal.new('7.5'))
      end
    end
  end
end
