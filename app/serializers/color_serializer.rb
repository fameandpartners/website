# if (type === ComponentType.Color && !component.value.startsWith('#')) {
#     image = {
#         url: `https://d1msb7dh8kb0o9.cloudfront.net/assets/product-color-images/${component.value}`
#     };
# } else if (component.image) {
#     image = {
#         url: component.image
#     };
# }
class ColorSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price, :hex

    def price
        66666
    end

    def hex
        '#66666'
    end
end