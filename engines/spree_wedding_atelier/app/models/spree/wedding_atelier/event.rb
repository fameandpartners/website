module Spree
  module WeddingAtelier
    class Event < ActiveRecord::Base
      has_many :event_assistants, class_name: 'Spree::WeddingAtelier::EventAssistant'
      has_many :assistants, through: :event_assistants, source: :user
      resourcify :event_roles, role_cname: 'Spree::WeddingAtelier::EventRole'

      attr_accessible :event_type,
                      :number_of_assistants,
                      :date,
                      :events_attributes,
                      :name

      after_create :sluggify

      validates_uniqueness_of :name

      private

      def sluggify
        update_attribute(:slug, name.parameterize) if slug.nil?
      end
    end
  end
end
