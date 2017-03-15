module WeddingAtelier
  class MoodboardEventSerializer < ActiveModel::Serializer
    include Sprockets::Helpers::RailsHelper
    include Sprockets::Helpers::IsolatedHelper
    include ActionView::Helpers::AssetTagHelper

    has_many :invitations, serializer: WeddingAtelier::InvitationSerializer
    has_many :dresses
    has_many :assistants, serializer: WeddingAtelier::UserSerializer

    attributes :id, :date, :number_of_assistants, :name, :slug, :dresses, :remaining_days, :owner_id, :current_cart_total

    def invitations
      object.invitations.pending
    end

    def date
      object.date.strftime("%m/%d/%Y")
    end

    def remaining_days
      (object.date - Date.today).to_i
    end

    def current_cart_total
      scope.current_order.display_total.to_s
    end
  end
end
