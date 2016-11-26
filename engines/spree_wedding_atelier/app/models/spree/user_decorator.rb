Spree::User.class_eval do
  attr_accessor :event_role

  attr_accessible :height,
                  :dress_size,
                  :wedding_atelier_signup_step,
                  :events_attributes,
                  :event_role

  has_many :event_assistants, class_name: 'Spree::WeddingAtelier::EventAssistant'
  has_many :events, through: :event_assistants, source: :event
  accepts_nested_attributes_for :events
  rolify role_cname: 'Spree::WeddingAtelier::EventRole', role_join_table_name: 'spree_wedding_atelier_users_event_roles'

  def create_wedding
    events.create(event_type: 'wedding')
  end

  def wedding_atelier_signup_complete?
    wedding_atelier_signup_step == 'completed'
  end
end
