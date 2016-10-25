module NextLogistics
  class ReturnRequestProcess < ActiveRecord::Base
    include AASM

    # Persist the process for future reference
    # Invoke worker which will:
    # => prepare excel spreadsheet (just receive it from a presenter)
    # => send FTP file

    aasm do
      state :created, initial: true
      state :asn_file_uploaded
      state :asn_received

      event :asn_file_was_uploaded do
        transitions from: :created, to: :asn_file_uploaded
      end

      event :asn_was_received do
        transitions from: :asn_file_uploaded, to: :asn_received
      end
    end

    belongs_to :order_return_request

    scope :not_failed, -> { where(failed: false) }
    scope :months_old, -> (months) { where(updated_at: months.to_i.months.ago..Time.zone.now) }

    attr_accessible :order_return_request

    validates :order_return_request, presence: true

    def start_process
      save! if from_australia?
    end

    def upload_to_next
      # Upload File to Next FTP
      # Email customer with instructions (customer.io?)
    end

    private

    def from_australia?
      order_return_request.order.ship_address.country.iso3 == 'AUS'
    end
  end
end
