module Admin
  class ShipmentTracking
    include ActiveModel::Validations

    attr_accessor :ref_number, :order_number, :style, :tracking_number

    validates_presence_of :order_number
    validates_presence_of :tracking_number

    validates :order_number, :format => { :with => /\AR\d+\Z/i }

    def initialize(ref_number, order_number, style, tracking_number)
      @ref_number       = ref_number || :unknown
      @order_number     = order_number
      @style            = style || :unknown
      @tracking_number  = tracking_number.to_s
    end

    def to_s
      {
        ref_number: ref_number,
        order_number: order_number,
        style: style,
        tracking_number: tracking_number,
        valid: valid?,
        errors: errors
      }.to_json
    end
  end
end