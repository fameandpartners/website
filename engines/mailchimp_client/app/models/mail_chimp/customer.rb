module MailChimp
  class Customer

    class Create

      def self.call(user)
        return true if Exists.(user)

        user_presenter = UserPresenter.new(user)
        user_params = user_presenter.to_h

        Store.current.customers.create(body: user_params)
        true
      rescue StandardError => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n\t")
        false
      end
    end

    class Exists

      def self.call(user)
        Store.current.customers(user.id.to_s).retrieve
        true
      rescue Gibbon::MailChimpError
        false
      end
    end
  end
end
