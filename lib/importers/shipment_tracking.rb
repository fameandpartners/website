module Importers
  class ShipmentTracking < FileImporter

    attr_accessor :shipment_infos, :shippable_orders, :styles, :matching_orders

    def import
      info "Start Tracking Numbers Import"
      info "File: #{csv_file}"

      parse_file
      #print_validation_errors
      find_orders
      update_orders
      print_summary

      info "Done"
    end

    private

    def parse_file
      csv = CSV.read(csv_file, headers: true, skip_blanks: true)
      @shipment_infos = []

      info "Parsing File"
      csv.each_with_index do |row, index|
        ref_no       = row['SR#'].presence || (index - 1) # Headers
        order_number = sanitize(row['ORDER NO']).presence
        style        = sanitize(row['STYLE']).presence
        tracking     = sanitize(row['TRACKING #']).presence

        next if order_number.nil? and tracking.nil?

        @shipment_infos << Admin::ShipmentTracking.new(ref_no, order_number, style, tracking)
      end
      info "Parsed: rows=#{shipment_infos.count}"
    end

    def print_validation_errors
      shipment_infos.map { |i| warn(i) unless i.valid? }
    end

    def find_orders
      info "Find Orders"
      @matching_orders ||= Spree::Order.where(number: order_numbers)
      @shippable_orders ||= Spree::Order.
        where(number: order_numbers).
        where('shipment_state != ?', 'shipped').
        select(&:can_ship?)
    end

    def update_orders
      info "Update Orders"

      total = shippable_orders.count
      shippable_orders.each_with_index do |order, index|
        prefix = "#{index}/#{total}"

        unless order.can_ship?
          warn "#{prefix} - Cannot update unshippable order #{order.number}"
          next
        end

        shipment = order.shipments.first

        if shipment.state_transitions.empty? or shipment.state == 'shipped'
          warn "#{prefix} - Cannot ship already shipped shipment for order #{order.number}"
          next
        end

        #MONKEY PUNCH!
        # Stops the shipped email being delivered
        def shipment.send_shipped_email
          nil
        end

        begin  # Sigh.
          shipment.tracking = shipment_info_for_order(order).tracking_number
          # Trigger the shipment state machine from `pending` -> `ready`
          shipment.save!
          shipment.reload
          # Trigger the shipment state `ship`
          shipment.ship!

          order.reload
          order.save!

          info "#{prefix} - Marked order shipped: #{order.number}"
        rescue StateMachine::InvalidTransition => e
          # binding.pry
          raise e
        end
      end
    end

    def print_summary
      info "Parsed: rows=#{shipment_infos.count}"
      info "Valid: shipment_infos=#{valid_shipment_infos.count}"

      info "Unique Order #: #{order_numbers.uniq.count}"
      info "Matching Orders: #{matching_orders.count}"
      info "Shippable Orders: #{shippable_orders.count}"
      info "Missing Orders: #{missing_orders.count}"
      info missing_orders.join ', '
    end

    def valid_shipment_infos
      shipment_infos.select &:valid?
    end

    def shipment_info_for_order(order)
      valid_shipment_infos.select { |si| si.order_number == order.number }.first
    end

    def order_numbers
      valid_shipment_infos.collect &:order_number
    end

    def missing_orders
      order_numbers.uniq - shippable_orders.collect(&:number) - matching_orders.collect(&:number)
    end

    # "R711622522\u00a0 ".gsub /[^\w]/, ''
    # => "R711622522"
    def sanitize(content)
      content.to_s.gsub(/[^\w]/, '')
    end
  end
end
