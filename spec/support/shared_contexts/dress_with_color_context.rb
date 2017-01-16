# Useful for when you want a product + color and size option types populated
# Note: instead of using factories to assume relationships, they're explicit declared on this context to give other developers
# A certain level of how data is structure around `Spree::Product`s, `Spree::OptionType`s, `Spree::OptionValue`s and `ProductColorValue`s

shared_context 'dress with colors and sizes' do
  # `Spree::OptionType`s
  let!(:color_option_type) { FactoryGirl.create(:option_type, :color) }
  let!(:size_option_type) { FactoryGirl.create(:option_type, :size) }

  # `Spree::OptionValue`s
  let!(:size_small) { FactoryGirl.create(:option_value, name: 'US0/AU4', presentation: 'US0 / AU4', option_type: size_option_type) }
  let!(:size_big) { FactoryGirl.create(:option_value, name: 'US20/AU24', presentation: 'US20 / AU24', option_type: size_option_type) }

  let!(:color_red) { FactoryGirl.create(:option_value, name: 'magma-red', presentation: 'Magma Red', option_type: color_option_type) }
  let!(:color_blue) { FactoryGirl.create(:option_value, name: 'blue', presentation: 'Blue', option_type: color_option_type) }

  # `Spree::Product`s
  let!(:dress) { FactoryGirl.create(:dress, name: 'Bianca Dress', sku: 'ABC123') }

  # `ProductColorValue`
  let!(:product_color_value_red) { FactoryGirl.create(:product_color_value, product: dress, option_value: color_red) }
  let!(:product_color_value_blue) { FactoryGirl.create(:product_color_value, product: dress, option_value: color_blue) }
end
