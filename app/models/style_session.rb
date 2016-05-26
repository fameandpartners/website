class StyleSession
  include ActiveModel::Validations

  SESSION_TYPES = %w{ default birthday prom }

  attr_accessor :full_name,
    :session_type,
    :email,
    :phone,
    :birthday,
    :skype_id,
    :preference1,
    :preference2,
    :preference3,
    :timezone

  validates_presence_of :email, :full_name
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  def to_key
    nil
  end
end
