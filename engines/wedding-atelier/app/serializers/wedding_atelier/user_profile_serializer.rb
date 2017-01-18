module WeddingAtelier
  class UserProfileSerializer < ActiveModel::Serializer
   attributes :height

   has_one :dress_size, serializer: OptionValueSerializer
  end
end
