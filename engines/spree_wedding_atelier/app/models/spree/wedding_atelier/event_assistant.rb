module Spree
  module WeddingAtelier
    class EventAssistant < ActiveRecord::Base
      belongs_to :user, class_name: Spree.user_class
      belongs_to :event, class_name: 'Spree::WeddingAtelier::Event'
    end
  end
end
