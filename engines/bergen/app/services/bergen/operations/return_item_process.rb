require 'aasm'

module Bergen
  module Operations
    class ReturnItemProcess < ActiveRecord::Base
      include AASM

      # => Verifying + creating style master
      # => Checking style master creation
      # => Checking ASN receival

      aasm do
        state :operation_created, initial: true
        state :style_master_created
        state :tracking_number_updated
        state :asn_created
        state :asn_received

        event :style_master_was_created do
          transitions from: :operation_created, to: :style_master_created
        end

        # @deprecated Shippo has been deprecated (WEBSITE-617). 8th November 2016
        event :tracking_number_was_updated do
          transitions from: :style_master_created, to: :tracking_number_updated
        end

        event :asn_was_created do
          transitions from: :tracking_number_updated, to: :asn_created
        end

        event :asn_was_received do
          transitions from: :asn_created, to: :asn_received
        end
      end

      belongs_to :return_request_item

      scope :not_failed, -> { where(failed: false) }
      scope :months_old, -> (months) { where(updated_at: months.to_i.months.ago..Time.zone.now) }

      attr_accessible :return_request_item

      validates :return_request_item, presence: true

      def start_process
        puts "UUUUUUUUUUUUUUUUU-------start_process----------------UUUUUUUUUU"
        if from_the_usa? && item_for_return?
          save!
        end
      end

      def verify_style_master
        if self.operation_created?
          Workers::VerifyStyleMasterWorker.perform_async(self.id)
        end
      end

      def update_tracking_number
        if self.style_master_created?
          self.tracking_number_was_updated
          self.save
        end
      end

      def create_asn
        if self.tracking_number_updated?
          Workers::CreateAsnWorker.perform_async(self.id)
        end
      end

      def receive_asn
        if self.asn_created?
          Workers::ReceiveAsnWorker.perform_async(self.id)
        end
      end

      private

      def item_for_return?
        return_request_item.return_or_exchange?
      end

      def from_the_usa?
        return_request_item.order.shipping_address.country.iso3 == 'USA'
      end
    end
  end
end
