require 'spec_helper'

describe Spree::OptionValue, type: :model do
  context "#colors" do
    it 'returns options values for color option type' do
      color_option_type = create(:option_type, :color)
      option = Spree::OptionValue::ProductColor.new(name: 'foo-red', presentation: 'foo-red')
      option.option_type_id = color_option_type.id
      option.save
      
      expect(Spree::OptionValue.colors.size).to eq(1)
      expect(Spree::OptionValue::ProductColor.first.name).to eq('foo-red')
    end

    it 'returns empty relation if no color option type' do
      expect(Spree::OptionValue.colors).to be_empty
      expect(Spree::OptionValue::ProductColor.all).to be_empty
    end
  end

  context "#sizes" do
    before :each do
      allow(SiteVersion).to receive(:australia).and_return(SiteVersion.new(permalink: 'au'))
      allow(SiteVersion).to receive(:usa).and_return(SiteVersion.new(permalink: 'us'))
    end

    let(:product_size) { Spree::OptionValue::ProductSize.new(name: '10') }

    it "returns au presentation" do
      expect(product_size.au_presentation).to eq('AU-14')
    end

    it "returns us presentation" do
      expect(product_size.us_presentation).to eq('US-10')
    end

    it 'returns options values for size option type' do
      size_option_type = create(:option_type, :size)
      option = Spree::OptionValue::ProductSize.new(name: '10')
      option.option_type_id = size_option_type.id
      option.save!
      
      expect(Spree::OptionValue.sizes.size).to eq(1)
      expect(Spree::OptionValue::ProductSize.first.presentation).to eq("AU-14/US-10")
    end

    it 'returns empty relation if no size option type' do
      expect(Spree::OptionValue.sizes).to be_empty
      expect(Spree::OptionValue::ProductSize.all).to be_empty
    end
  end
end
