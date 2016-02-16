module PinRefunds
  module ChargeFindRefunds
    def refunds
      @refunds ||= fetch_refunds
    end

    def fetch_refunds
      response = self.class.get(URI.parse(PinPayment.api_url).tap{|uri| uri.path = "/1/charges/#{token}/refunds" })

      response.map{ |item| PinPayment::Refund.new(item.delete('token'), item) }
    end
  end
end
