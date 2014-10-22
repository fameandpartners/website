class StyleConsultation
  include ActiveModel::Validations

  attr_accessor :name, :email, :phone, :to_key

  validates :name, presence: true
  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true
  validates :phone, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def send_request
    if self.valid?
      StyleConsultationMailer.style_consultation(self).deliver
      true
    else
      false
    end
  end
end
