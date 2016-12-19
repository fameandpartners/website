module WeddingAtelier
  class MoodboardEventSerializer < ActiveModel::Serializer
    include Sprockets::Helpers::RailsHelper
    include Sprockets::Helpers::IsolatedHelper
    include ActionView::Helpers::AssetTagHelper

    has_many :invitations

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

    def dresses
      object.dresses.collect do |dress|
        {
          id: dress.id,
          title: [dress.user.first_name, " Dress"].join(' '),
          love_count: 0, #TODO, real implementation of loving
          image: image_path(dress.image),
          author: dress.author_name,
          price: dress.price.format
        }
      end
    end

    def remaining_days
      (object.date - Date.today).to_i
    end
  end
end
