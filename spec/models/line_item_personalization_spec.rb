require 'spec_helper'

describe LineItemPersonalization, type: :model do
  context "price" do
    let(:personalization) { build(:personalization) }
    let(:line_item)       { build(:spree_line_item, price: 9.99) }
    let(:discount)        { double('Discount price', amount: 50, size: 50) }

    context "#size_cost" do
      let(:default_size_cost) { BigDecimal.new(100) }

      it "returns 0 for default sizes" do
        expect(personalization).to receive(:add_plus_size_cost?).and_return(false)
        expect(
          personalization.calculate_size_cost(default_size_cost)
        ).to eql(BigDecimal.new(0))
      end

      it "adds price for custom size" do
        expect(personalization).to receive(:size).and_return(build(:option_value))
        expect(personalization).to receive(:add_plus_size_cost?).and_return(true)
        expect(
          personalization.calculate_size_cost(default_size_cost)
        ).to eql(default_size_cost)
      end

      it "returns discounted size prices" do
        expect(personalization).to receive(:add_plus_size_cost?).and_return(true)
        size = build(:option_value)
        expect(size).to receive(:discount).and_return(double(size: 50, amount: 50))
        expect(personalization).to receive(:size).and_return(size)

        expect(
          personalization.calculate_size_cost(default_size_cost)
        ).to eql(default_size_cost * 0.5)
      end
    end

    context "#color_cost" do
      before do
        personalization.product = Spree::Product.new
      end

      it "works if no data" do
        expect(personalization.color_cost).to eql(BigDecimal.new(0))
      end

      it "returns 0 for basic color" do
        personalization.color = Spree::OptionValue.new
        expect(personalization).to receive(:basic_color?).and_return(true)

        expect(personalization.color_cost).to eql(BigDecimal.new(0))
      end

      it "adds price for custom color" do
        personalization.color = Spree::OptionValue.new
        expect(personalization).to receive(:basic_color?).and_return(false)

        expect(personalization.color_cost).to eql(BigDecimal.new('16.0'))
      end

      it "returns discounted price for custom colour" do
        expect(personalization).to receive(:color).at_least(:once).and_return(
          double('Spree::OptionValue', discount: discount)
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
          build_list(:customisation_value, 2, price: 15.0)
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
