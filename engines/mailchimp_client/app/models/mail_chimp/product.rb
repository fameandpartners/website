module MailChimp
  class Product

    class Create

      def self.call(product)
        return false unless product.present?
        return true if Exists.(product)

        product_params = {
          id:       product.sku.strip,
          title:    product.name,
          variants: [{ id: product.master.sku.strip, title: product.master.sku.strip }] # MailChimp will not create product without any variant
        }

        Store.current.products.create(body: product_params)
        true
      rescue StandardError => e
        Raven.capture_exception(e)
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call(product)
        Store.current.products(product.sku.strip).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
