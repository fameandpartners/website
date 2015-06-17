class WeddingConsultation
  include ActiveModel::Validations
  MAX_WORD_COUNT = 500

  attr_accessor :full_name, :email, :phone, :dob, :location, :skype_id, :timezone, :info

  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true

  validates :full_name, :email, :phone, :dob, :location, :timezone, :info, presence: true

  validate do
    if info.present?
      if info.split(/\s+/).size > MAX_WORD_COUNT
        errors.add(:info, "maximum #{MAX_WORD_COUNT} words allowed")
      end
    end
  end

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
