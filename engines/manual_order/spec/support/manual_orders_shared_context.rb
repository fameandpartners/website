RSpec.shared_context 'manual order context' do
  let!(:country) { create(:country, name: 'United States of America') }
  let!(:state) { create(:state, name: 'California', country: country) }
  let!(:ship_address) { create(:address, address1: 'Street 1', address2: 'Complement', zipcode: '123-321', city: 'Los Angeles', state: state) }

  let!(:size_option_type) { create(:option_type, :size) }
  let!(:color_option_type) { create(:option_type, :color) }
  let!(:dress_size) { create(:product_size, name: 'US10/AU14', option_type: size_option_type) }
  let!(:dress_color) { create(:product_colour, name: 'blue', option_type: color_option_type) }

  let!(:product) { create(:dress, name: 'Stylight', sku: 'product-sku') }
  let!(:variant) { create(:dress_variant, sku: 'SKU-VERIFY', product: product, option_values: [dress_size, dress_color], is_master: false) }
  let!(:product_color_value) { create(:product_color_value, product: product, option_value: dress_color) }
  let!(:price) { create(:price, variant: variant, currency: 'USD') }
  let!(:shipping_method) { create(:simple_shipping_method) }
  let!(:site_version) { create(:site_version, name: 'USA', permalink: 'us', currency: 'USD') }
end
