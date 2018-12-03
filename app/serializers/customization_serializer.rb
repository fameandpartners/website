class CustomizationSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price
    
    def presentation
        object['customisation_value']['presentation']
    end

    def name
        object['customisation_value']['name']
    end

    def price
        BigDecimal.new(object['customisation_value']['price'] || 0) * 100 #TODO
    end
end