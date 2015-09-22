require 'spec_helper'

describe Spree::OptionValue, type: :model, memoization_support: true do
  before :each do
    Spree::OptionValue.delete_all
    Spree::OptionType.delete_all
    Spree::OptionValuesGroup.delete_all

    rememoize(Spree::OptionType, :@color)
    rememoize(Spree::OptionType, :@size)
  end

  context "#colors" do
    it 'returns options values for color option type' do
      color_option_type = create(:option_type, :color)
      color_option_type.option_values.create(name: 'foo-red', presentation: 'foo-red')

      expect(Spree::OptionValue.colors.size).to eq(1)
      expect(Spree::OptionValue.colors.first.name).to eq('foo-red')
    end

    it 'returns empty relation if no color option type' do
      expect(Spree::OptionValue.colors).to be_empty
    end
  end

  context "#sizes" do
    it 'returns options values for size option type' do
      size_option_type = create(:option_type, :size)
      size_option_type.option_values.create(name: 'x-foo-size', presentation: 'x-foo-size')
      
      expect(Spree::OptionValue.sizes.size).to eq(1)
      expect(Spree::OptionValue.sizes.first.name).to eq('x-foo-size')
    end

    it 'returns empty relation if no size option type' do
      expect(Spree::OptionValue.sizes).to be_empty
    end
  end
end
