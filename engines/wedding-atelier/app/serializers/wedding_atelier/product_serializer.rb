module WeddingAtelier
  class ProductSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :description,
               :image,
               :presentation,
               :price,
               :variant_id,
               :sku

    has_many :styles, serializer: WeddingAtelier::CustomisationValueSerializer
    has_many :fits, serializer: WeddingAtelier::CustomisationValueSerializer
    has_many :lengths, serializer: WeddingAtelier::CustomisationValueSerializer
    has_many :fabrics, serializer: WeddingAtelier::CustomisationValueSerializer

    def presentation
      object.name
    end

    def styles
      object.customisation_values.by_type(:style)
    end

    def fits
      object.customisation_values.by_type(:fit)
    end

    def lengths
      object.customisation_values.by_type(:length)
    end

    def fabrics
      object.customisation_values.by_type(:fabric)
    end

    def image
      image = object.images.first
      image.present? ? image.attachment(:small) : '/assets/wedding-atelier/customization_experience/default_dress.png'
    end

    def variant_id
      object.master.id
    end
  end
end
