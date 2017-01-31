module WeddingAtelier
  class Event < ActiveRecord::Base
    belongs_to :owner, class_name: 'Spree::User'

    has_many :event_assistants, class_name: 'WeddingAtelier::EventAssistant'
    has_many :assistants, through: :event_assistants, source: :user
    has_many :dresses, class_name: 'WeddingAtelier::EventDress'
    has_many :invitations

    resourcify :event_roles, role_cname: 'WeddingAtelier::EventRole'

    attr_accessible :event_type,
                    :number_of_assistants,
                    :date,
                    :events_attributes,
                    :name,
                    :owner_id

    after_create :sluggify

    validates_uniqueness_of :name, case_sensitive: false
    validates_presence_of :name, :date
    validates :number_of_assistants, numericality: true

    def to_param
      slug
    end

    def assistant_permitted?(user)
      assistants.include? user
    end

    def date=(val)
      date = begin
        Date.strptime(val, '%m/%d/%Y') if val.present?
      rescue
        val
      end
      write_attribute(:date, date || val)
    end

    private

    def sluggify
      update_attribute(:slug, name.parameterize)
    end

  end
end
