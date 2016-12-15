module WeddingAtelier
  class ProductSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :description,
               :image,
               :colours,
               :fabrics,
               :styles,
               :lengths,
               :fits,
               :sizes

   def colours
     object.option_values_of('Colour')
   end

   def fabrics
     object.option_values_of('Fabric')
   end

   def styles
     object.option_values_of('Style')
   end

   def lengths
     object.option_values_of('Length')
   end

   def fits
     object.option_values_of('Fit')
   end

   def sizes
     object.option_values_of('Size')
   end

   def image
     image = object.images.first
     image.present? ? image.attachment(:small) : '/assets/wedding-atelier/customization_experience/default_dress.png'
   end
  end
end
