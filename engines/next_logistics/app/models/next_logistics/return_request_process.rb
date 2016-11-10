require 'aasm'

module NextLogistics
  class ReturnRequestProcess < ActiveRecord::Base
    include AASM

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

    attr_accessible :order_return_request

    validates :order_return_request, presence: true

    def start_process
      save! if from_australia? && has_item_for_return?
    end

    def upload_to_ftp
      Workers::UploadToFtpWorker.perform_async(self.id)
      # TODO: Email customer with instructions (customer.io?)
    end

    private

    def from_australia?
      order_return_request.order.ship_address.country.iso3 == 'AUS'
    end

    def has_item_for_return?
      order_return_request.return_request_items.any?(&:return_or_exchange?)
    end
  end
end
