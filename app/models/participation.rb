class Participation
  include ActiveModel::Validations

  attr_accessor :email

  validates :email,
            format: {
              with: Devise.email_regexp
            }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
