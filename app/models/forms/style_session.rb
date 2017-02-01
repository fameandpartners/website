module Forms
  class StyleSession < Reform::Form
    AVAILABLE_TIMES               = %w(morning midday afternoon evening)
    SESSION_TYPES                 = ['Email', 'Video Chat', 'Phone']
    TYPES_REQUIRES_EMAIL          = ['Email', 'Video Chat']
    TYPES_REQUIRES_PHONE          = ['Phone']
    TYPES_REQUIRES_TIMEZONE       = ['Phone', 'Video Chat']
    TYPES_REQUIRES_PREFERRED_TIME = ['Phone', 'Video Chat']

    property :full_name, virtual: true
    property :session_type, virtual: true
    property :email, virtual: true
    property :phone, virtual: true
    property :preferred_time, virtual: true
    property :timezone, virtual: true

    validates :full_name, presence: true
    validates :session_type, presence: true

    validates :email,
              format: { with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i },
              if:     :requires_email

    validates :phone,
              presence: true,
              if:       :requires_phone

    validates :timezone,
              presence: true,
              if:       :requires_timezone

    validates :preferred_time,
              presence: true,
              if:       :requires_preferred_time

    def requires_email
      TYPES_REQUIRES_EMAIL.include?(session_type)
    end

    def requires_phone
      TYPES_REQUIRES_PHONE.include?(session_type)
    end

    def requires_timezone
      TYPES_REQUIRES_TIMEZONE.include?(session_type)
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


