Spree::User.class_eval do
  attr_accessible :height,
                  :dress_size,
                  :wedding_atelier_signup_step

  has_and_belongs_to_many :events
  rolify role_cname: 'EventRole'

  def create_wedding
    events.create(event_type: 'wedding')
  end
end
