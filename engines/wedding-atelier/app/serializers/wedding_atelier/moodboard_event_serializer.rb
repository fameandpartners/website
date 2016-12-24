module WeddingAtelier
  class MoodboardEventSerializer < ActiveModel::Serializer
    include Sprockets::Helpers::RailsHelper
    include Sprockets::Helpers::IsolatedHelper
    include ActionView::Helpers::AssetTagHelper

    has_many :invitations
    has_many :dresses

    attributes :id, :date, :number_of_assistants, :name, :slug, :assistants, :dresses, :remaining_days

    def date
      object.date.strftime("%d/%m/%Y")
    end

    def assistants
      object.assistants.collect do |assistant|
        {
          user: {
            id: assistant.id,
            name: assistant.full_name,
            role: 'Bridesmaid'
          }
        }
      end
    end

    def invitations
      object.invitations.collect do |invitation|
        {
          invitation: {
            state: invitation.state,
            user_email: invitation.user_email,

          }
        }
      end
    end

    def remaining_days
      (object.date - Date.today).to_i
    end
  end
end
