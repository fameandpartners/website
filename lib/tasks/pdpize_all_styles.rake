namespace :data do
desc 'Run through all styles'
  task :pdpize_all_styles => :environment do

    Spree::Product.not_deleted.find_each do |prod|
      product = Products::DetailsResource.new(
        product: prod
      ).read

      color = product.available_options.colors.default.first

      product.color_id = color&.id
      product.color_name = color&.name

      product.making_option_id = product.making_options.first.try(:id)
      product.fit = product&.fit&.gsub("Height", ", Height")
      product.fit = product&.fit&.gsub("Hips", ", Hips")
      product.fit = product&.fit&.gsub("Waist",", Waist")

      pdp_obj = {
        # paths: env["REQUEST_URI"],  #todo: work this out with adam
        product: product,
        # discount: product_discount,
        images: product.all_images,
        sizeChart: product.size_chart_data,
        siteVersion: 'USA',
        flags: {
          afterpay: Features.active?(:afterpay),
          fastMaking: !Features.active?(:getitquick_unavailable)
        }
      }

      resp = RestClient.post "#{configatron.node_pdp_url}/pdp", {'data' => pdp_obj}.to_json, {content_type: :json}
      JSON.parse(resp)
    end

  end
end
