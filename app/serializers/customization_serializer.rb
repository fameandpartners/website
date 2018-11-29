class CustomizationSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price
    
    def presentation
        object['customisation_value']['presentation']
    end

    def name
        object['customisation_value']['name']
    end

    def price
        object['customisation_value']['price'] * 100
    end
end