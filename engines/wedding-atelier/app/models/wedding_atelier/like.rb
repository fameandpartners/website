module WeddingAtelier
  class Like < ActiveRecord::Base
    belongs_to :event_dress, class_name: 'WeddingAtelier::EventDress', counter_cache: true
    belongs_to :user, class_name: Spree.user_class.name

    attr_accessible :event_dress_id, :user_id

    validates_uniqueness_of :event_dress_id, scope: :user_id
  end
end
