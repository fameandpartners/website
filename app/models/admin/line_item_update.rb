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

    PROCESS_STATES = [:invalid, :fail, :skip, :pending, :process]

    PROCESS_STATES.each do |m|
      define_method m do |reason, at = DateTime.now|
        mark_state(m, reason, at)
      end
    end


    def valid_tracking?
      tracking_number =~ /\d{10}/
    end

    def tracking_mismatch?
      shipment && shipment.tracking.present? && shipment.tracking != tracking_number
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


    def detect_spree_matches
      lit = self

      match_errors = []
      unless order = ::Spree::Order.find_by_number(lit.order_number)
        lit.match_errors = [:no_order]
        return
      end

      lit.order = order

      if id_match = order.line_items.detect {|i| i.id.to_s == raw_line_item }
        lit.line_item = id_match
      else
        style_matches = items_matching_style(order, lit.style_name)

        if style_matches.empty?
          match_errors << :no_style_in_order

        elsif style_matches.count == 1
          lit.line_item = style_matches.first.item

        elsif style_matches.count > 1
          match_errors << :multiple_of_style
          colour_matches = style_matches.select { |item|
            lit.colour.starts_with? item.colour_name.downcase
          }

          if colour_matches.count == 1
            lit.line_item = colour_matches.first.item
          elsif colour_matches.count > 1
            match_errors << :multiple_of_colour

            size_matches = colour_matches.select { |item|
              item.country_size.downcase == lit.size
            }

            if size_matches.empty?
              match_errors << :no_size_matches
            elsif size_matches.count == 1
              lit.line_item = size_matches.first.item
            else
              errors << :multiple_of_size
            end
          end
        end
      end

      if lit.line_item
        lit.shipment = order.shipments.detect { |ship| ship.line_items.include?(lit.line_item) }
      end

      if lit.shipped? && lit.tracking_mismatch?
        match_errors << :tracking_number_mismatch
      end

      unless lit.valid_tracking?
        match_errors << :invalid_tracking_number
      end

      lit.match_errors = match_errors unless match_errors.empty?

    end


    private

    def items_matching_style(order, style)
      order.line_items.select do |i|
        i.variant.sku.to_s.start_with? style
      end.collect { |item|
        ::Orders::LineItemPresenter.new(item, order)
      }
    end



    def mark_state(state, reason, at = DateTime.now)
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
