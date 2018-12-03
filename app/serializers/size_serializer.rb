class SizeSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price, :display_price

    def presentation
        parts = object.presentation.split('/').map(&:strip)
        if parts.length == 2
            if scope[:currency] == 'AUD'
                parts[1]
            else
                parts [0]
            end
        else
            object.presentation
        end
    end

    def price
        0
    end

    def display_price
        ''
    end


end