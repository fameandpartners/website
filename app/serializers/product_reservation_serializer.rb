class ProductReservationSerializer < ActiveModel::Serializer
  self.root = false
  attributes :product_id, :color, :school_name, :school_year, :formal_name
end
