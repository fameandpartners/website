module MailChimp
  class Customer

    class Create

      def self.call(user)
        return true if Exists.(user)

        store_id = ENV['MAILCHIMP_STORE_ID']
        user_presenter = UserPresenter.new(user)
        user_params = user_presenter.read

        GibbonInstance.().ecommerce.stores(store_id).customers.create(body: user_params)
        true
      rescue StandardError => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call(user)
        store_id = ENV['MAILCHIMP_STORE_ID']
        GibbonInstance.().ecommerce.stores(store_id).customers(user.id.to_s).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
