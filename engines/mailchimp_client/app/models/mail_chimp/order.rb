module MailChimp
  class Order

    class Create

      def self.call(order)
        return false unless order.present?
        return true if Exists.(order)

        store_id = ENV['MAILCHIMP_STORE_ID']
        order_params = OrderPresenter.new(order).read
        GibbonInstance.().ecommerce.stores(store_id).orders.create(body: order_params)
        true
      rescue StandardError => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call(order)
        store_id = ENV['MAILCHIMP_STORE_ID']
        GibbonInstance.().ecommerce.stores(store_id).orders(order.number).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
