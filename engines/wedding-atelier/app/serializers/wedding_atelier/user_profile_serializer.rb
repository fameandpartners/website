module WeddingAtelier
  class UserProfileSerializer < ActiveModel::Serializer
    attributes :dress_size,
               :dress_size_id
               :height

   def dress_size
     object.dress_size.name
   end
  end
end
