module MailChimp
  class Store

    def self.current
      Client.request.ecommerce.stores(ENV['MAILCHIMP_STORE_ID'])
    end

    class Create

      def self.call
        return true if Exists.()

        store_params = {
          id: ENV['MAILCHIMP_STORE_ID'],
          list_id: ENV['MAILCHIMP_LIST_ID'],
          name: 'Fame and Partners',
          currency_code: 'USD'
        }

        Client.request.ecommerce.stores.create(body: store_params)
        true
      rescue StandardError => e
        Raven.capture_exception(e)
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call
        Client.request.ecommerce.stores(ENV['MAILCHIMP_STORE_ID']).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
