module WeddingAtelier
  class Event < ActiveRecord::Base
    has_many :event_assistants, class_name: 'WeddingAtelier::EventAssistant'
    has_many :assistants, through: :event_assistants, source: :user
    has_many :dresses, class_name: 'WeddingAtelier::EventDress'

    resourcify :event_roles, role_cname: 'WeddingAtelier::EventRole'

    attr_accessible :event_type,
                    :number_of_assistants,
                    :date,
                    :events_attributes,
                    :name

    after_create :sluggify

    validates_uniqueness_of :name
    validates_presence_of :name, :date

    def to_param
      slug
    end

    def assistant_permitted?(user)
      assistants.include? user
    end

    def invitations
      Invitation.pending.where(event_slug: slug)
    end

    private

    def sluggify
      update_attribute(:slug, name.parameterize)
    end
  end
end
