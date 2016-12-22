module WeddingAtelier
  class OptionValueSerializer < ActiveModel::Serializer
    attributes :id, :name, :presentation, :value, :image

    def image
      object.image.present? ? object.image : '/assets/noimage/small1.png'
    end
  end
end
