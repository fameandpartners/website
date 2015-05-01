module Admin
  class ReallyShipTheShipment
    include ActiveModel::Validations

    attr_reader :shipment, :tracking_number, :order

    validates_presence_of :tracking_number, :order, :shipment
    validate :shippable_order?, :not_already_shipped?

    def initialize(shipment, tracking_number)
      @shipment        = shipment
      @order           = shipment.order
      @tracking_number = tracking_number
    end

    def ship!
      return errors.messages unless valid?
      shipment.tracking = tracking_number
      shipment.ship!
    # rescue StateMachine::InvalidTransition => e
    #   binding.pry
    end

    private

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
