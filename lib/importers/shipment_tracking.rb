module Importers
  class ShipmentTracking < FileImporter

    attr_accessor :shipment_infos, :shippable_orders, :styles, :matching_orders, :shipped_orders

    def import
      preface

      parse_file
      print_validation_errors
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
      shipment_infos.reject(&:valid?).map { |i| warn(i.messages) }
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

        shipment = order.shipments.first
        tracking_number = shipment_info_for_order(order).tracking_number

        shipper = Admin::ReallyShipTheShipment.new(shipment, tracking_number, re_raise: true)

        unless shipper.valid?
          warn "#{prefix} Order:#{order.number} #{shipper.errors.full_messages.to_sentence}"
          unshippable_shipments << shipment
        end

        #MONKEY PUNCH!
        # Stops the shipped email being delivered
        def shipment.send_shipped_email
          nil
        end

        begin
          shipper.ship!
          shipped_shipments << shipment
        rescue StateMachine::InvalidTransition => e
          error "#{prefix} Order:#{order.number} #{e.message}"
          unshippable_shipments << shipment
        end
      end
    end

    def shipped_shipments
      @shipped_shipments ||= []
    end

    def unshippable_shipments
      @unshippable_shipments ||= []
    end

    def print_summary
      info "Parsed: rows=#{shipment_infos.count}"
      info "Valid: shipment_infos=#{valid_shipment_infos.count}"


      info "Unique Order #: #{order_numbers.uniq.count}"
      info "Matching Orders: #{matching_orders.count}"
      info "Shippable Orders: #{shippable_orders.count}"

      info "Shipped Shipments: #{shipped_shipments.count}"
      error "Unshippable Shipments: #{unshippable_shipments.count}"
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
