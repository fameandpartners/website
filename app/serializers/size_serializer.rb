class SizeSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price


    def price
        0
    end


end