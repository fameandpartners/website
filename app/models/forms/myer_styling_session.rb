module Forms
  class MyerStylingSession < Reform::Form
    AVAILABLE_TIMES               = ['Thursday, 11-2PM', 'Friday, 11-2PM']
    SESSION_TYPES                 = ['In person stylist appointment at Myer Store, Sydney City', 'In person stylist appointment at Myer Store, Westfield Bondi Junction', 'Email', 'Video Chat', 'Phone']
    TYPES_REQUIRES_EMAIL          = ['In person stylist appointment at Myer Store, Sydney City', 'In person stylist appointment at Myer Store, Westfield Bondi Junction', 'Email', 'Video Chat']
    TYPES_REQUIRES_PHONE          = ['In person stylist appointment at Myer Store, Sydney City', 'In person stylist appointment at Myer Store, Westfield Bondi Junction', 'Phone']
    TYPES_REQUIRES_PREFERRED_TIME = ['In person stylist appointment at Myer Store, Sydney City', 'In person stylist appointment at Myer Store, Westfield Bondi Junction', 'Phone', 'Video Chat']

    property :full_name, virtual: true
    property :session_type, virtual: true
    property :email, virtual: true
    property :phone, virtual: true
    property :preferred_time, virtual: true

    validates :full_name, presence: true
    validates :session_type, presence: true

    validates :email,
              format: { with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i },
              if:     :requires_email

    validates :phone,
              presence: true,
              if:       :requires_phone

    validates :preferred_time,
              presence: true,
              if:       :requires_preferred_time

    def requires_email
      TYPES_REQUIRES_EMAIL.include?(session_type)
    end

    def requires_phone
      TYPES_REQUIRES_PHONE.include?(session_type)
    end

    def requires_preferred_time
      TYPES_REQUIRES_PREFERRED_TIME.include?(session_type)
    end

    # Form Helpers

    def session_types
      SESSION_TYPES
    end

    def available_times
      AVAILABLE_TIMES
    end
  end
end
