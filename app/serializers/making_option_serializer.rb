class MakingOptionSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :delivery_period

    def presentation
        object.name
    end

    def name
        object.code
    end
end