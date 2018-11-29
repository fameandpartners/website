class FabricSerializer < ActiveModel::Serializer
    attributes :presentation, :name

    def price
        666666
    end
end