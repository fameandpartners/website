namespace :reports do
  desc 'SKUs for all time'
  task :skus => :environment do

    Spree::Product.unscoped do
      Spree::Variant.find_each do |variant|
        begin
        global_sku = GlobalSku.where(sku: variant.sku).first_or_initialize(
            :sku                => variant.sku,
            :style_number       => variant.product.master.sku,
            :product_name       => variant.product.name,
            :size               => variant.dress_size.try(:name),
            :color_id           => variant.dress_color.try(:id),
            :color_name         => variant.dress_color.try(:name),
            :customisation_id   => nil,
            :customisation_name => nil,
            :height_value       => 'standard',
            :data               => nil,
            :product_id         => variant.product_id,
            :variant_id         => variant.id
          )
        global_sku.save!

        rescue StandardError => e
          puts e.message
          next
        end
      end
    end

    Spree::Variant.unscoped do

      Spree::LineItem.find_each do |li|
        next unless li.order.present?

        begin
          lip   = Orders::LineItemPresenter.new(li, Orders::OrderPresenter.new(li.order))

          # Some very old orders are missing variants.
          next unless lip.item.variant.present?

          # Skip incomplete orders
          next unless lip.order.order.complete?

          scope = GlobalSku.where(sku: lip.sku)

          if scope.exists?
            next
          end


          global_sku = GlobalSku.create(
            :sku                => lip.sku,
            :style_number       => lip.style_number,
            :product_name       => lip.style_name,
            :size               => lip.size,
            :color_id           => lip.colour.try(:id),
            :color_name         => lip.colour_name,
            :customisation_id   => nil,
            :customisation_name => nil,
            :height_value       => lip.height,
            # :data               => lip.customisations.to_s,
            :product_id         => lip.item.variant.product_id,
            :variant_id         => lip.item.variant_id
          )

          global_sku.save!

        rescue StandardError => e
          puts e.message
          next
        end
      end
    end
  end
end
