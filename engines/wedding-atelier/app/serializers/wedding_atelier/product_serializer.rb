module WeddingAtelier
  class ProductSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :description

  end
end
