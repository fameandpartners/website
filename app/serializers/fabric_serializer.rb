class FabricSerializer < ActiveModel::Serializer
    attributes :presentation, :name, 
    
    #for legacy checkout
    :display_price

    def price
        666666 #TODO
    end

    def display_price
        6666
    end
end