require 'spec_helper'

describe LineItemPersonalization, type: :model do
  context "price" do
    let(:line_item)       { build(:line_item, price: 9.99, customizations: '[]') }
    let(:personalization) { build(:personalization) }
   
    let(:discount)        { double('Discount price', amount: 50, size: 50) }

    context "#size_cost" do
      let(:default_size_cost) { BigDecimal.new(100) }

      it "returns 0" do
        personalization.line_item = line_item
        expect(
          personalization.calculate_size_cost(default_size_cost)
        ).to eql(BigDecimal.new(0))
      end
    end

    context "#color_cost" do
      before do
        personalization.product = Spree::Product.new
      end

      it "works if no data" do
        expect(subject.color_cost).to eql(BigDecimal.new(0))
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
        personalization.line_item = line_item
        expect(personalization.customizations_cost).to eql(BigDecimal.new(0))
      end

      it "returns sum of prices" do
        expect(personalization).to receive(:customization_values).at_least(:once).and_return(
          JSON.parse(build_list(:customisation_value, 2, price: 15.0).to_json)
        )
        expect(personalization.customizations_cost).to eql(BigDecimal.new('30.0'))
      end

      xit "returns sum of discounted prices" do
        personalization.line_item = line_item
        customization = build(:customisation_value, price: 15.0)
        expect(customization).to receive(:discount).and_return(discount)
        expect(personalization).to receive(:customization_values).and_return(JSON.parse([customization].to_json))

        expect(personalization.customizations_cost).to eql(BigDecimal.new('7.5')) #TODO: Bring this back when its actually useful
      end
    end
  end

  describe '#height' do
    describe 'validation' do
      it { is_expected.to validate_inclusion_of(:height).in_array(%w(tall standard petite)) }
    end

    describe 'values' do
      subject(:personalization) { described_class.new }

      it('is standard by default') do
        expect(personalization.height).to eq 'standard'
      end

      it 'still allows setting custom values' do
        personalization.height = 'foobar'
        expect(personalization.height).to eq 'foobar'
      end
    end
  end
end
