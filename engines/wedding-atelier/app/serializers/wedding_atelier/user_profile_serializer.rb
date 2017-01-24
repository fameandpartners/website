module WeddingAtelier
  class UserProfileSerializer < ActiveModel::Serializer
    attributes :dress_size,
               :height
  end
end
