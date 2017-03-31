module WeddingAtelier
  class Event < ActiveRecord::Base
    belongs_to :owner, class_name: 'Spree::User'

    has_many :event_assistants, class_name: 'WeddingAtelier::EventAssistant'
    has_many :assistants,
              through: :event_assistants,
              source: :user
    has_many :dresses, class_name: 'WeddingAtelier::EventDress'
    has_many :invitations

    resourcify :event_roles, role_cname: 'WeddingAtelier::EventRole'

    attr_accessible :event_type,
                    :number_of_assistants,
                    :date,
                    :events_attributes,
                    :name,
                    :owner_id

    before_save :sluggify
    validates_presence_of :date, :name
    validates_numericality_of :number_of_assistants, greater_than_or_equal_to: 0

    def assistant_permitted?(user)
      assistants.include?(user) || user.email =~ /^.*@fameandpartners.com$/
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
      self.slug = name.parameterize
    end

  end
end
