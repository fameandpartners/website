module WeddingAtelier
  class EventRole < ActiveRecord::Base
    has_and_belongs_to_many :spree_users, :join_table => :spree_wedding_atelier_users_event_roles, class_name: Spree.user_class.name

    belongs_to :resource,
               :polymorphic => true

    validates :resource_type,
              :inclusion => { :in => Rolify.resource_types },
              :allow_nil => true

    scopify
    # attr_accessible :title, :body
  end
end
