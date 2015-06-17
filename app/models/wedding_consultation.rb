class WeddingConsultation
  include ActiveModel::Validations

  attr_accessor :full_name, :email, :phone, :dob, :location, :skype_id, :timezone

  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true

  validates :full_name, :email, :phone, :dob, :location, :timezone, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      if respond_to?("#{name}=")
        send("#{name}=", value)
      end
    end
  end

  def persisted?
    false
  end

  def to_key
    nil
  end
end
