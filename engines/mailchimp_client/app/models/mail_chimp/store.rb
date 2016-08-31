module MailChimp
  class Store

    class Create

      def self.call
        return true if Exists.()

        store_params = {
          id: ENV['MAILCHIMP_STORE_ID'],
          list_id: ENV['MAILCHIMP_LIST_ID'],
          name: 'Fame and Partners',
          currency_code: 'USD'
        }

        GibbonInstance.().ecommerce.stores.create(body: store_params)
        true
      rescue StandardError => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call
        GibbonInstance.().ecommerce.stores(ENV['MAILCHIMP_STORE_ID']).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
