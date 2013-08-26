class CustomDressRequest
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :email, :description, :event_date

  validates :first_name, :last_name, presence: true
  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true

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
      CustomDressesMailer.request_custom_dress(self).deliver
      true
    else
      false
    end
  end
end
