class Return
  include ActiveModel::Validations

  attr_accessor :reason

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def to_key
    nil
  end
end
