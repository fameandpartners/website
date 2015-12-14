class FeatureFlag
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :flag, :enabled

  validates :flag, presence: true

  validate do
    if self.flag.present?
      errors.add(:flag, " already used.") if Features.features.include? (self.flag.to_sym)
    end
  end

  def persisted?
    false
  end

  def initialize(attributes = {})
    assign_attributes(attributes)
  end

  def assign_attributes(values)
    values.each do |k, v|
      send("#{k}=", v)
    end
  end

  def save
    self.enabled == 'true' ? Features.activate(self.flag) : Features.deactivate(self.flag)
  end

  def state_string
    self.enabled == 'true' ? 'Enabled' : 'Disabled'
  end

end
