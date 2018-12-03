class TaxSerializer < ActiveModel::Serializer
    attributes :label, :amount
end