class FabricsProductSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price,
    
    #for legacy checkout
    :display_price

    def price
        object.price_in(scope[:currency])
    end

    def name
        object.fabric.name
    end

    def presentation
        object.fabric.presentation
    end

    def display_price
        '$' + '%.2f' %  object.price_in(scope[:currency])
    end
end