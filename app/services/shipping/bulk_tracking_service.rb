module Shipping
  class BulkTrackingService

    attr_reader :bulk_update, :user

    def initialize(bulk_update, user)
      @bulk_update = bulk_update
      @user        = user
    end

    def detect_spree_matches
      bulk_update.line_item_updates.map &:detect_spree_matches
      bulk_update.save
    end

    def update_make_states
      bulk_update.line_item_updates.each do |liu|
        next unless liu.line_item && liu.make_state.present?

        valid_new_state = Fabrication::STATES.fetch(liu.make_state) do |provided_state|
          matched_state_value = Fabrication::STATES.values.detect do |v|
            v.downcase == provided_state.downcase.strip
          end
          [
            Fabrication::STATES.key(provided_state),
            Fabrication::STATES.key(matched_state_value),
          ].compact.first
        end

        if valid_new_state
          UpdateFabrication.state_change(liu.line_item, user, valid_new_state)
        else
          liu.match_errors = liu.match_errors | [:invalid_make_state]
          liu.save
        end
      end
    end

    def group_shipments
      bulk_update.line_item_updates.each do |lit|
        next :invalid unless lit.order && lit.line_item
        next :no_shipment unless lit.shipment

        spree_shipment = lit.shipment

        if spree_shipment.shipped? && spree_shipment.tracking == lit.tracking_number
          next :ok
        end

        if spree_shipment.shipped? && spree_shipment.tracking != lit.tracking_number
          next :error
        end

        # Setup Tracking Numbers
        unless spree_shipment.shipped?
          if spree_shipment.tracking != lit.tracking_number
            spree_shipment.tracking = lit.tracking_number
            spree_shipment.save
          end
        end
      end
    end

    # TODO: 15-06-2016. TTL 2 weeks. Vestigial method from old grouping shipment process. After tested with a couple of bulk uploads, this should disappear
    # Note: the old `group_shipments` method does not updates tracking numbers for orders with multiple line items because...¯\_(ツ)_/¯
    # Probably part of an older goal. There are serious throwaway code below (like, `binding.pry`) in a comment, so probably had a reason, and it's not valid anymore
    # def group_shipments
    #   bulk_update.line_item_updates.each do |lit|
    #     next :invalid unless lit.order && lit.line_item
    #
    #     if lit.shipment
    #       if lit.shipment.shipped? && lit.shipment.tracking == lit.tracking_number
    #         next :ok
    #       end
    #
    #       if lit.shipment.shipped? && lit.shipment.tracking != lit.tracking_number
    #         next :error
    #       end
    #     else
    #       # Handle not in a shipment
    #       next :no_shipment
    #     end
    #
    #     # editable_shipments = lit.order.shipments.select { |s| s.tracking.nil? && s.editable_by?(:anyone) }
    #
    #
    #     # Simple case
    #     if lit.order.line_items.reject(&:promotional_gift?).count == 1
    #       unless lit.shipment.shipped?
    #         if lit.shipment.tracking != lit.tracking_number
    #           lit.shipment.tracking = lit.tracking_number
    #         end
    #         lit.shipment.save
    #       end
    #
    #       # TODO : WHAT HERE?
    #
    #     else
    #       next :whatever
    #       # same_number = lit.order.shipments.detect {|s| s.tracking == lit.tracking_number }
    #       #
    #       # if same_number
    #       #   binding.pry
    #       # end
    #       #
    #       # no_tracking = editable_shipments.select {|s| s.tracking.nil? }
    #       #
    #       #
    #       # if no_tracking
    #       #   binding.pry
    #       #   # no_tracking.tracking = lit.tracking_number
    #       #   # no_tracking.line_items = [lit.line_item]
    #       # end
    #     end
    #
    #     # Find unshipped shipment on order with same tracking number
    #     # add self to that
    #
    #
    #     # if lit.shipment.tracking.empty? && lit.shipment.line_items.include?(lit.line_item)
    #     #   lit.shipment.tracking
    #     #
    #     # end
    #
    #
    #   end
    # end



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

        # Gifts shouldn't stop the marking of a shipment as shipped.
        shipment_item_count = shipment.line_items.count

        if shipment_item_count == 1 && possible_to_ship
          shipper = Admin::ReallyShipTheShipment.new(shipment, shipment.tracking)

          if shipper.valid?
            shipper.ship! do
              shipment.line_items.map do |li|
                UpdateFabrication.state_change(li, user, 'shipped')
              end
              tracking_items.map do |ti|
                ti.process(:shipped)
              end
            end
          end

          if shipper.error?
            tracking_items.map do |ti|
              ti.fail(:failed_to_ship!)
              ti.shipment_errors = shipper.errors.full_messages.uniq
            end
          end
        end

        if shipment_item_count > 1 && !shipment.shipped?
          tracking_items.map do |ti|
            ti.pending(:multiple_items)
          end
        end

      end
      bulk_update.save
    end
  end
end
