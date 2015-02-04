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
    Spree::Preference.where(key: key.to_s).first.try(:value)
  end

  def self.update(key, value, value_type = :string)
    preference = Spree::Preference.where(key: key).first_or_initialize
    if value_type.present?
      preference.value_type = value_type
      preference.value = convert_value(value, value_type)
    else
      preference.value_type = get_value_type(value)
      preference.value = value
    end
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

    def self.convert_value(value, value_type)
      case value_type.downcase.to_sym
      when :string
        value.to_s
      when :boolean
        value.to_s.match(/^(true|t|yes|y|1)$/i).present?
      else
        value.to_s
      end
    end
end
