module WeddingAtelier
  class UserProfileSerializer < ActiveModel::Serializer
    attributes :height, :height_group

    has_one :dress_size, serializer: OptionValueSerializer

    def height_group
      WeddingAtelier::Height.height_group(object.height)
    end
  end
end
