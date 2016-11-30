Spree::User.class_eval do
  attr_accessor :event_role

  attr_accessible :height,
                  :dress_size,
                  :wedding_atelier_signup_step,
                  :events_attributes,
                  :event_role,
                  :trend_updates,
                  :user_profile_attributes

  has_one :user_profile, class_name: 'WeddingAtelier::UserProfile', foreign_key: :spree_user_id, dependent: :destroy
  has_many :event_assistants, class_name: 'WeddingAtelier::EventAssistant'
  has_many :events, through: :event_assistants, source: :event
  accepts_nested_attributes_for :events, :user_profile
  rolify role_cname: 'WeddingAtelier::EventRole', role_join_table_name: 'wedding_atelier_users_event_roles'

  def create_wedding
    events.create(event_type: 'wedding')
  end

  def wedding_atelier_signup_complete?
    wedding_atelier_signup_step == 'completed'
  end
end
