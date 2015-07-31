require 'net/http'

# Product::CurrencyConverter.new('AUD', 'USD').get_rate
module Products
  class CurrencyConverter
    # add rates
    def initialize(from = 'AUD', to = 'USD')
      @source_currency = from
      @target_currency = to
    end

    def get_rate
      Products::CurrencyConverter.get_rate(@source_currency, @target_currency)
    end

    class << self
      def get_rate(from, to)
        return BigDecimal.new(1) if from == to
        rate = Products::CurrencyConverter.load_rate(from, to)
        if rate["err"].blank? && rate["from"] == from && rate["to"] == to
          rate["rate"]
        else
          nil # or 1.0000 ?
        end
      end

      def load_rate(from, to)
        uri = URI("http://rate-exchange.appspot.com/currency")
        uri.query = URI.encode_www_form(from: from, to: to)
        res = Net::HTTP.get_response(uri)

        JSON.parse(res.body)
      rescue Exception => e
        { "err" => e.to_s }
      end
    end
  end
end
