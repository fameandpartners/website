module Admin
  class LineItemUpdate < ActiveRecord::Base

    attr_accessible :row_number,
                    :order_date,
                    :order_number,
                    :style_name,
                    :size,
                    :quantity,
                    :colour,
                    :dispatch_date,
                    :tracking_number,
                    :delivery_method,
                    :match_errors,
                    :setup_ship_errors,
                    :shipment_errors,
                    :make_state,
                    :raw_line_item

    serialize :match_errors, Array
    serialize :setup_ship_errors, Array
    serialize :shipment_errors, Array

    belongs_to :order, :class_name => 'Spree::Order'
    belongs_to :line_item, :class_name => 'Spree::LineItem'
    belongs_to :shipment, :class_name => 'Spree::Shipment'

    def valid_tracking?
      tracking_number =~ /\d{10}/
    end

    def tracking_mismatch?
      shipment && shipment.tracking != tracking_number
    end

    def tracking_matches?
      !tracking_mismatch?
    end

    def shipped?
      shipment && shipment.shipped?
    end

    def shipment_tracking_state
      if tracking_matches?
        if shipped?
          'color:green;'
        else
          'color:blue;'
        end
      else
        if shipped?
          'color:red;'
        else
          'color:orange;'
        end
      end
    end

    def skip(reason, at = DateTime.now)
      mark_state(:skip, reason, at)
    end

    def process(reason, at = DateTime.now)
      mark_state(:process, reason, at)
    end

    def fail(reason, at = DateTime.now)
      mark_state(:fail, reason, at)
    end

    private

    def mark_state(state, reason, at)
      self.state          = state
      self.process_reason = reason
      self.processed_at   = at
    end

    #
    # Sample numbers:
    #
    # Couriers Please - CPAPZNS0000062
    # DHL - 7762808966
  end
end
