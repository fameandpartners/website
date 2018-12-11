class FabricationSerializer < ActiveModel::Serializer
    attributes :state, :date

    def date
        object.updated_at || object.created_at
    end
end