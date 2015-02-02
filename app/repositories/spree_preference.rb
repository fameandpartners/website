# class designed to load spree preferences from db
# mostly just wrapper to Spree::Preference class,
# but we can cache it as we like or change storage later

module Repositories; end
class Repositories::SpreePreference
  def self.read_all(*keys)
    keys = Array.wrap(keys.first) if keys.size == 1

    result = {}
    keys.each do |key|
      result[key.to_sym] = read(key)
    end
    HashWithIndifferentAccess.new(result)
  end

  def self.read(key)
    Spree::Preference.where(key: key.to_s).first.try(:value) || ''
  end

  def self.update(key, value, value_type = :string)
    preference = Spree::Preference.where(key: key).first_or_initialize
    preference.value = value
    preference.value_type = value_type || get_value_type(value)
    preference.save
  end

  private

    def self.get_value_type(value)
      if value.is_a?(BigDecimal)
        :decimal
      elsif value.is_a?(Integer)
        :integer
      elsif value.is_a?(TrueClass) or value.is_a?(FalseClass)
        :boolean
      elsif value.is_a?(String)
        :string
      else
        nil
      end
    end
end
