module NextLogistics
  class ReturnRequest < ActiveRecord::Base
    belongs_to :order_return_request

    validates :order_return_request, presence: true

    class Create
      # @param [OrderReturnRequest] an OrderReturnRequest
      # @raise [ArgumentError] if order_return_request param is not an OrderReturnRequest
      def self.call(order_return_request:)
        raise ArgumentError unless order_return_request.is_a?(OrderReturnRequest)

        if from_australia?(order_return_request)
          # Persist the process for future reference
          # Invoke worker which will:
          # => prepare excel spreadsheet (just receive it from a presenter)
          # => send FTP file


          parent.save!
        end
      end

      def self.from_australia?(order_return_request)
        order_return_request.order.ship_address.country.iso3 == 'AUS'
      end
    end
  end
end
