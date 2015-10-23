namespace :reports do
  task :products_colours => :environment do
    require 'enumerable_csv'
    class ProductColoursReport
      include EnumerableCSV

      def each
        return to_enum(__callee__) unless block_given?
        scope.find_each do |product|
          s = Products::SelectionOptions.new(product: product)

          default_colours = s.send :default_product_colors
          custom_colours  = s.send :extra_product_colors

          default_colours.each do |colour|
            row = {
              product:        product.name,
              sku:            product.sku,
              colour_type:    'default',
              colour_code:    colour.name,
              colour_display: colour.presentation
            }
            yield row
          end

          custom_colours.each do |colour|
            row = {
              product:        product.name,
              sku:            product.sku,
              colour_type:    'custom',
              colour_code:    colour.name,
              colour_display: colour.presentation
            }
            yield row
          end
        end
      end

      def scope
        Spree::Product.active
      end

    end
    ProductColoursReport.new.report
  end
end
