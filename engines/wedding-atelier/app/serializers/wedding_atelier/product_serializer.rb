module WeddingAtelier
  class ProductSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :description,
               :image,
               :presentation

   has_many :styles, serializer: WeddingAtelier::OptionValueSerializer
   has_many :fits, serializer: WeddingAtelier::OptionValueSerializer

   def presentation
     object.name
   end

   def styles
     object.option_values_of('Style')
   end

   def fits
     object.option_values_of('Fit')
   end

   def image
     image = object.images.first
     image.present? ? image.attachment(:small) : '/assets/wedding-atelier/customization_experience/default_dress.png'
   end
  end
end
