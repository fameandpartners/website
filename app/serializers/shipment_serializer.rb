class ShipmentSerializer < ActiveModel::Serializer
    attributes :tracking_number, :tracking_url, :state, :shipped_at

    def tracking_number
        object.tracking
    end
end