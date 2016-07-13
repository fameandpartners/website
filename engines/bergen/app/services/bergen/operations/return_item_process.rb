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
        state :asn_created
        state :asn_received

        event :style_master_was_created do
          transitions from: :operation_created, to: :style_master_created
        end

        event :asn_was_created do
          transitions from: :style_master_created, to: :asn_created
        end

        event :asn_was_received do
          transitions from: :asn_created, to: :asn_received
        end
      end

      belongs_to :return_request_item

      scope :not_failed, -> { where(failed: false) }

      attr_accessible :return_request_item

      validates :return_request_item, presence: true

      def start_process
        if from_the_usa? && item_for_return?
          save!
          verify_style_master
        end
      end

      def verify_style_master
        Workers::VerifyStyleMasterWorker.perform_async(self.id)
      end

      def create_asn
        Workers::CreateAsnWorker.perform_async(self.id)
      end

      def receive_asn
        Workers::ReceiveAsnWorker.perform_async(self.id)
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
