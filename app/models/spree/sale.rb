class Spree::Sale < ActiveRecord::Base
  has_many :discounts

  DISCOUNT_TYPES = {
    1 => 'Fixed',
    2 => 'Percentage'
  }

  default_value_for :is_active, false

  alias_attribute :active, :is_active

  accepts_nested_attributes_for :discounts, allow_destroy: true

  attr_accessible :is_active,
                  :discount_size,
                  :discount_type,
                  :discounts_attributes

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

  scope :active, lambda { where(is_active: true) }

  has_many :discounts

  after_save do
    ActiveSupport::Cache::RedisStore.new(Rails.application.config.cache_store.last).clear
  end

  DISCOUNT_TYPES.each do |id, name|
    define_method "#{name.downcase}?" do
      self.discount_type.eql?(id)
    end
  end

  def apply(price, surryhills)
    if fixed?
      discount_size < price ? price - discount_size : BigDecimal.new(0)
    elsif percentage?
      unless surryhills
        price * (BigDecimal.new(100) - discount_size) / 100
      else
        price * (BigDecimal.new(100) - 80) / 100  
      end
    end
  end
end
