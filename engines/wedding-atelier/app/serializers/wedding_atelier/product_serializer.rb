module WeddingAtelier
  class ProductSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :description,
               :image,
               :presentation,
               :price

   has_many :styles, serializer: WeddingAtelier::CustomisationValueSerializer
   has_many :fits, serializer: WeddingAtelier::CustomisationValueSerializer

   def presentation
     object.name
   end

   def styles
     object.customisation_values.where(customisation_type: 'style')
   end

   def fits
     object.customisation_values.where(customisation_type: 'fit')
   end

   def image
     image = object.images.first
     image.present? ? image.attachment(:small) : '/assets/wedding-atelier/customization_experience/default_dress.png'
   end
  end
end
