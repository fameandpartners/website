module Shipping
  class BulkTrackingService

    attr_reader :bulk_update, :user

    def initialize(bulk_update, user)
      @bulk_update = bulk_update
      @user = user
    end

    def detect_spree_matches
      bulk_update.line_item_updates.map &:detect_spree_matches
      bulk_update.save
    end

    def update_make_states
      bulk_update.line_item_updates.each do |liu|
        next unless liu.line_item && liu.make_state.present?

        valid_new_state = Fabrication::STATES.fetch(liu.make_state) { |state| Fabrication::STATES.key(state) }

        if valid_new_state
          UpdateFabrication.state_change(liu.line_item, user, valid_new_state)
        end
      end
    end

    def group_shipments
      bulk_update.line_item_updates.each do |lit|
        next :invalid unless lit.order && lit.line_item

        if lit.shipment
          if lit.shipment.shipped? && lit.shipment.tracking == lit.tracking_number
            next :ok
          end

          if lit.shipment.shipped? && lit.shipment.tracking != lit.tracking_number
            next :error
          end
        else
          # Handle not in a shipment
          next :no_shipment
        end

        # editable_shipments = lit.order.shipments.select { |s| s.tracking.nil? && s.editable_by?(:anyone) }


        # Simple case
        if lit.order.line_items.count == 1
          unless lit.shipment.shipped?
            if lit.shipment.tracking != lit.tracking_number
              lit.shipment.tracking = lit.tracking_number
            end
            lit.shipment.save
          end

          # TODO : WHAT HERE?

        else
          next :whatever
          # same_number = lit.order.shipments.detect {|s| s.tracking == lit.tracking_number }
          #
          # if same_number
          #   binding.pry
          # end
          #
          # no_tracking = editable_shipments.select {|s| s.tracking.nil? }
          #
          #
          # if no_tracking
          #   binding.pry
          #   # no_tracking.tracking = lit.tracking_number
          #   # no_tracking.line_items = [lit.line_item]
          # end
        end

        # Find unshipped shipment on order with same tracking number
        # add self to that


        # if lit.shipment.tracking.empty? && lit.shipment.line_items.include?(lit.line_item)
        #   lit.shipment.tracking
        #
        # end


      end
    end


    def fire_valid_shipments
      shipments_with_items = bulk_update.line_item_updates.group_by { |lit| lit.shipment }

      shipments_with_items.each do |shipment, tracking_items|
        unless shipment
          tracking_items.map do |ti|
            ti.invalid(:no_shipment)
          end
          next :no_shipment
        end

        unless tracking_items.all?(&:valid_tracking?)
          tracking_items.map do |ti|
            ti.invalid(:invalid_tracking)
          end
          next :invalid_tracking
        end

        possible_to_ship = !shipment.shipped? && tracking_items.all?(&:valid_tracking?)

        if shipment.shipped?
          tracking_items.map do |ti|
            next if ti.state.present?

            if ti.tracking_mismatch?
              ti.fail(:bad_previous_shipment)
            else
              ti.skip(:already_shipped)
            end
          end
          next :already_shipped
        end

        if shipment.line_items.count == 1 && possible_to_ship
          shipper = Admin::ReallyShipTheShipment.new(shipment, shipment.tracking)

          if shipper.valid? && shipper.ship! && ! shipper.error?
            shipment.line_items.map do |li|
              UpdateFabrication.state_change(li, user, 'shipped')
            end

            tracking_items.map do |ti|
              ti.process(:shipped)
            end
          else
            tracking_items.map do |ti|
              ti.fail(:failed_to_ship!)
              ti.shipment_errors = shipper.errors.full_messages.uniq
            end
          end
        end

        if shipment.line_items.count > 1 && !shipment.shipped?
          tracking_items.map do |ti|
            ti.pending(:multiple_items)
          end
        end

      end
      bulk_update.save
    end
  end
end
