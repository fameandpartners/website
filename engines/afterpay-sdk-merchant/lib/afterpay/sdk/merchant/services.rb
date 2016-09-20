module Afterpay::SDK::Merchant

  module Services
    def ping(options = {}, http_header = {})
      get('ping', options, http_header)
    end

    def configuration(options = {}, http_header = {})
      get('configuration', options, http_header)
    end

    def get_order(options = {}, http_header = {})
      order_token = options.fetch(:token) { raise ArgumentError, 'Order token (:token) is required' }
      get("orders/#{order_token}", options, http_header)
    end

    def create_order(options = {}, http_header = {})
      post('orders', options, http_header)
    end

    def direct_capture_payment(options = {}, http_header = {})
      options.fetch(:token) { raise ArgumentError, 'Order token (:token) is required' }
      post('payments/capture', options, http_header)
    end

    def authorize_payment(options = {}, http_header = {})
      options.fetch(:token) { raise ArgumentError, 'Order token (:token) is required' }
      post('payments', options, http_header)
    end

    def void_payment(options = {}, http_header = {})
      payment_id = options.fetch(:payment_id) { raise ArgumentError, 'Payment ID (:payment_id) is required' }
      post("payments/#{payment_id}/void", options, http_header)
    end

    def capture_payment(options = {}, http_header = {})
      payment_id = options.fetch(:payment_id) { raise ArgumentError, 'Payment ID (:payment_id) is required' }
      post("payments/#{payment_id}/void", options, http_header)
    end

    def update_shipping_courier(options = {}, http_header = {})
      payment_id = options.fetch(:payment_id) { raise ArgumentError, 'Payment ID (:payment_id) is required' }
      put("payments/#{payment_id}/courier", options, http_header)
    end

    def get_payment(options = {}, http_header = {})
      payment_id = options.fetch(:payment_id) do
        order_token = options.fetch(:token) { raise ArgumentError, 'Payment ID (:payment_id) or order token (:token) is required' }
        "token:#{order_token}"
      end
      get("payments/#{payment_id}", options, http_header)
    end

    def get_payments(options = {}, http_header = {})
      get('payments', options, http_header)
    end

    def creat_refund(options = {}, http_header = {})
      amount = options.fetch(:amount) { raise ArgumentError, 'Refund amount (:amount) is required' }
      payment_id = options.fetch(:payment_id) { raise ArgumentError, 'Payment ID (:payment_id) is required' }
      post("payments/#{payment_id}/refund", options, http_header)
    end

  end
end
