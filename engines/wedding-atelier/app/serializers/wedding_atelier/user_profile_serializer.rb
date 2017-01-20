module WeddingAtelier
  class UserProfileSerializer < ActiveModel::Serializer
    attributes :height, :height_group

    has_one :dress_size, serializer: OptionValueSerializer

    def height_group
      WeddingAtelier::Height.definitions.detect {|_, h| h.include?(object.height) }.first
    end
  end
end
