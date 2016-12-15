module WeddingAtelier
  class OptionValueSerializer < ActiveModel::Serializer
    attributes :id, :name, :presentation, :value
  end
end
