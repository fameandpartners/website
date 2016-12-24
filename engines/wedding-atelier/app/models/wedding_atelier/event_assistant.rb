module WeddingAtelier
  class EventAssistant < ActiveRecord::Base
    belongs_to :user, class_name: Spree.user_class.name
    belongs_to :event, class_name: 'WeddingAtelier::Event'
  end
end
