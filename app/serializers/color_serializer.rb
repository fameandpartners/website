class ColorSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price, :hex, :image

    def price
        0
    end

    def hex
        object.color_hex
    end

    def image
        object.color_image
    end
end