module Admin
  class ReallyShipTheShipment
    include ActiveModel::Validations

    attr_reader :shipment, :tracking_number, :order

    validates_presence_of :tracking_number, :order, :shipment
    validate :shippable_order?,
             :shippable_shipment?,
             :not_already_shipped?,
             :unless => :we_shipped?

    def initialize(shipment, tracking_number, re_raise: false)
      @shipment        = shipment
      @order           = shipment.order
      @tracking_number = tracking_number
      @we_shipped      = false
      @re_raise        = !! re_raise
    end

    def ship!
      return unless valid?
      shipment.tracking = tracking_number
      if shipment.ship!
        we_shipped!
        yield if block_given?
      end
    rescue StateMachine::InvalidTransition => e
      @status = :error
      errors[:base] << e.message
      raise e if @re_raise
    end

    def result
      {
        data: {
          order_number:    order.number,
          shipment_id:     shipment.id,
          tracking_number: tracking_number
        },
        status: status,
        errors: errors.full_messages
      }
    end

    def status
      @status ||= (valid? ? :valid : :invalid )
    end

    def error?
      @status == :error
    end

    private

    def we_shipped!
      errors.clear
      @we_shipped = true
    end

    def we_shipped?
      @we_shipped
    end

    def shippable_shipment?
      unless shipment.can_ship?
        errors.add :shipment, "#{shipment.number} is not shippable."
      end
    end

    def shippable_order?
      unless order.can_ship?
        errors.add :order, "#{order.number} is not shippable."
      end
    end

    def not_already_shipped?
      if shipment.shipped?
        errors.add :shipment, "#{shipment.number} is already shipped."
      end
    end
  end
end
