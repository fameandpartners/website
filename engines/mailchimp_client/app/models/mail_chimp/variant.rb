module MailChimp
  class Variant

    class Create

      def self.call(product, variant_sku)
        return false unless product.present? && variant_sku.present?
        return true if Exists.(product, variant_sku)

        variant_params = {
          id:    variant_sku.strip,
          title: product.name,
          sku:   variant_sku.strip
        }

        Store.current.products(product.sku.strip).variants.create(body: variant_params)
        true
      rescue StandardError => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call(product, variant_sku)
        Store.current.products(product.sku.strip).variants(variant_sku.strip).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
