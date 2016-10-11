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
        if from_the_usa? && item_for_return?
          save!
        end
      end

      def verify_style_master
        Workers::VerifyStyleMasterWorker.perform_async(self.id)
      end

      def update_tracking_number
        label = Shippo::Label.new(return_request_item).create

        order = return_request_item.order
        shipments = order.shipments.select do |shipment|
          shipment.line_items.any? {|line_item| line_item.id == return_request_item.line_item.id}
        end

        shipments.each do |shipment|
          shipment.tracking = label[:tracking_number]
          shipment.save
        end

        return_request_item.item_return.events.tracking_number_updated.create(
          shippo_tracking_number: label[:tracking_number],
          shippo_label_url:       label[:label_url]
        )
        self.tracking_number_was_updated
        self.save
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
