require 'log_formatter'

namespace :quality do
  class MismatchedShipmentsShippingMethods
    extend Forwardable
    def_delegators :@logger, :info, :debug, :warn, :error, :fatal

    def initialize(logdev: $stdout)
      @logger           = Logger.new(logdev)
      @logger.level     = Logger::INFO
      @logger.formatter = LogFormatter.terminal_formatter
    end

    def call
      info "Start: Mismatched Shipments & Shipping Methods"
      info "Fix orders with mismatched shipping methods for their region"
      update_orders

      stats.each do |k, v|
        info "#{k}: #{v}"
      end
    end

    private

    def stats
      @stats ||= Hash.new(0)
    end

    def scope
      states = %w{cart address delivery payment}
      @scope ||= Spree::Order.where(state: states).where('shipping_method_id is not null')
    end

    def update_orders
      total = scope.count

      stats[:total] = total
      info "Total Orders: #{total}"

      scope.find_each do |order|
        if order.payments.exists?
          stats[:skip] += 1
          debug "Skip - Payment Exists - #{order.number}, #{order.id}"
          next
        end
        if order.shipments.where("state != 'pending'").exists?
          stats[:skip] += 1
          debug "Skip - Shipment != 'pending' Exists - #{order.number}, #{order.id}"
          next
        end

        update_order(order)
      end
    end

    def update_order(order)
      shipping_method_id = Services::FindShippingMethodForOrder.new(order).get.try(:id)

      if shipping_method_id && order.shipping_method_id != shipping_method_id
        debug "Updating #{order.number}, #{order.id}"
        order.update_column(:shipping_method_id, shipping_method_id)
        order.shipments   = Shipping::AssignByFactory.new(order).create_shipments!
        stats[:processed] += 1
      else
        debug "Shipping method matches already #{order.number}, #{order.id}"
        stats[:skip] += 1
      end

    rescue ActiveRecord::RecordInvalid => record_error
      error "FAILED #{order.number}, #{order.id} - #{record_error.message}"
      stats[:failed] += 1
    rescue StandardError => e
      error e.message
      error e.backtrace
      stats[:errored] += 1
    end
  end

  desc 'Fix orders with incorrect shipping methods'
  task :mismatched_shipping_methods => :environment do
    MismatchedShipmentsShippingMethods.new.call
  end
end
