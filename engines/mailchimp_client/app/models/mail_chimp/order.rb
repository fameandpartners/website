module MailChimp
  class Order

    class Create

      def self.call(order)
        raise ArgumentError, 'a Spree::Order is required' unless order.is_a? Spree::Order
        return true if Exists.(order)

        order_params = OrderPresenter.new(order).to_h
        Store.current.orders.create(body: order_params)
        true
      rescue StandardError => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call(order)
        Store.current.orders(order.number).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
