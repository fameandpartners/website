Spree::User.class_eval do
  attr_accessible :height,
                  :dress_size,
                  :wedding_atelier_signup_step

  has_many :event_assistants, class_name: 'Spree::WeddingAtelier::EventAssistant'
  has_many :events, through: :event_assistants, source: :event
  rolify role_cname: 'Spree::WeddingAtelier::EventRole'

  def create_wedding
    events.create(event_type: 'wedding')
  end
end
