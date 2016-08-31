module MailChimp
  class Product

    class Create

      def self.call(product)
        return false unless product.present?
        return true if Exists.(product)

        store_id = ENV['MAILCHIMP_STORE_ID']
        product_params = {
          id:       product.sku[/\w+/],
          title:    product.name,
          variants: [{ id: product.master.sku[/\w+/], title: product.master.sku[/\w+/] }] # MailChimp will not create product without any variant
        }

        GibbonInstance.().ecommerce.stores(store_id).products.create(body: product_params)
        true
      rescue StandardError => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call(product)
        store_id = ENV['MAILCHIMP_STORE_ID']
        valid_product_sku = product.sku[/\w+/] # Some SKU's start with ' '
        GibbonInstance.().ecommerce.stores(store_id).products(valid_product_sku).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
