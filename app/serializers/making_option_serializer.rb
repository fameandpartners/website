class MakingOptionSerializer < ActiveModel::Serializer
    attributes :id, :presentation, :name, :display_price, :delivery_period

    def presentation
        object.name
    end

    def name
        object.code
    end

    def delivery_period
        object.display_delivery_period(Time.now)
    end

    def display_price
        object.display_price(@scope[:currency])
    end
end