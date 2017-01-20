module WeddingAtelier
  class InvitationSerializer < ActiveModel::Serializer
    attributes :state, :user_email
  end
end
