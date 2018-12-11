class MakingOptionSerializer < ActiveModel::Serializer
    attributes :id, :presentation, :name, :delivery_period, :description, :display_price

    def presentation
        object.name
    end

    def name
        object.code
    end

    def display_price
        object.display_price(@scope[:currency])
    end
end