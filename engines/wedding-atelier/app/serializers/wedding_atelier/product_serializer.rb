module WeddingAtelier
  class ProductSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :description,
               :image

   def image
     image = object.images.first
     image.present? ? image.attachment(:small) : '/assets/wedding-atelier/customization_experience/default_dress.png'
   end
  end
end
