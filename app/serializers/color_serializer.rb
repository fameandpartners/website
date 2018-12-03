class ColorSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price, :hex, :image

    def price
        66666 #TODO
    end

    def hex
        object.color_hex
    end

    def image
        object.color_image
    end
end