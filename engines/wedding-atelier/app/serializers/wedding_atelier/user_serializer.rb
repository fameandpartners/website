module WeddingAtelier
  class UserSerializer < ActiveModel::Serializer

    has_one :user_profile
    attributes :first_name

  end
end
