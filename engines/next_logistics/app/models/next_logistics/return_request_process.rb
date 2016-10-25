module NextLogistics
  class ReturnRequestProcess < ActiveRecord::Base
    include AASM

    # Persist the process for future reference
    # Invoke worker which will:
    # => prepare excel spreadsheet (just receive it from a presenter)
    # => send FTP file

    aasm do
      state :return_request_created, initial: true
      state :asn_file_uploaded
    end

    belongs_to :order_return_request

    validates :order_return_request, presence: true

    attr_accessible :order_return_request

    def start_process(order_return_request:)
      if from_australia?
        save!
      end
    end

    def upload_to_next

    end

    private

    def from_australia?
      order_return_request.order.ship_address.country.iso3 == 'AUS'
    end
  end
end
