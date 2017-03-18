# TODO: 13th January 2017 - Tiago Amaro: wedding-atelier engine SHOULD NOT add more properties/associations to the user model
# TODO: This `Spree::User` eval should be a `WeddingAtelier::User`

Spree::User.class_eval do
  attr_accessor :event_role

  attr_accessible :wedding_atelier_signup_step,
                  :events_attributes,
                  :event_role,
                  :trend_updates,
                  :user_profile_attributes,
                  :user_profile

  has_one :user_profile, class_name: 'WeddingAtelier::UserProfile', foreign_key: :spree_user_id, dependent: :destroy
  has_many :event_assistants, class_name: 'WeddingAtelier::EventAssistant'
  has_many :events, through: :event_assistants, source: :event
  has_many :wedding_atelier_dresses, class_name: 'WeddingAtelier::EventDress'
  has_many :likes, class_name: 'WeddingAtelier::Like'
  has_many :sent_invitations, class_name: 'WeddingAtelier::Invitation'
  accepts_nested_attributes_for :events, :user_profile
  rolify role_cname: 'WeddingAtelier::EventRole', role_join_table_name: 'wedding_atelier_users_event_roles'

  def create_wedding
    events.create(event_type: 'wedding')
  end

  def role_in_event(event)
    if event
      roles.where(resource_id: event.id).pluck(:name).first.to_s
    end
  end

  def update_role_in_event(role, event)
    current_role = role_in_event(event)
    unless current_role.eql?(role)
      begin
        remove_role current_role, event if current_role
      rescue NoMethodError
      end
      add_role role, event
    end
  end

  def wedding_atelier_signup_complete?
    ['completed', 'invite'].include? wedding_atelier_signup_step
  end
end
