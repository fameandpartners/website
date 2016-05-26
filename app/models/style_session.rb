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

  validates :full_name, presence: true
  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true
  validates :email, :phone, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  def to_key
    nil
  end
end
