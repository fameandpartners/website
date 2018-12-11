class TaxSerializer < ActiveModel::Serializer
    attributes :label, :price, :display_total

    def price
        @object.amount * 100
    end
    
    def display_total
        @object.amount.to_s
    end
end