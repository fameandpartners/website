class Spree::Sale < ActiveRecord::Base
  DISCOUNT_TYPES = {
    1 => 'Fixed',
    2 => 'Percentage'
  }

  default_value_for :is_active, false

  alias_attribute :active, :is_active

  attr_accessible :is_active,
                  :discount_size,
                  :discount_type

  validates :is_active,
            :inclusion => {
              :in => [true, false]
            }
  validates :discount_type,
            :presence => true,
            :inclusion => {
              :in => DISCOUNT_TYPES.keys
            }
  validates :discount_size,
            :numericality => {
              :greater_than_or_equal_to => 0
            }

  after_save do
    ActiveSupport::Cache::RedisStore.new.clear
  end

  DISCOUNT_TYPES.each do |id, name|
    define_method "#{name.downcase}?" do
      self.discount_type.eql?(id)
    end
  end

  def apply(price)
    if fixed?
      discount_size < price ? price - discount_size : BigDecimal.new(0)
    elsif percentage?
      price * (BigDecimal.new(100) - discount_size) / 100
    end
  end
end
