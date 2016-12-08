module WeddingAtelier
  class ProductSerializer < ActiveModel::Serializer
    attributes :name,
               :description

  end
end
