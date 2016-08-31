module MailChimp
  class Variant

    class Create

      def self.call(product, variant_sku)
        return false unless product.present? && variant_sku.present?
        return true if Exists.(product, variant_sku)

        valid_product_sku = product.sku[/\w+/]
        valid_variant_sku = variant_sku[/\w+/]
        store_id = ENV['MAILCHIMP_STORE_ID']
        variant_params = {
          id:    valid_variant_sku,
          title: product.name,
          sku:   valid_variant_sku
        }

        GibbonInstance.().ecommerce.stores(store_id).products(valid_product_sku).variants.create(body: variant_params)
        true
      rescue StandardError => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call(product, variant_sku)
        store_id = ENV['MAILCHIMP_STORE_ID']
        valid_product_sku = product.sku[/\w+/] # Some SKU's start with ' '
        valid_variant_sku = variant_sku[/\w+/]
        GibbonInstance.().ecommerce.stores(store_id).products(valid_product_sku).variants(valid_variant_sku).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
