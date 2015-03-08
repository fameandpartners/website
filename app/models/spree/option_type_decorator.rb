Spree::OptionType.class_eval do
  has_many :option_values_groups, class_name: 'Spree::OptionValuesGroup'

  class << self
    def color
      @color ||= where(name: 'dress-color').first
    end

    def size
      @size ||= where(name: 'dress-size').first
    end
  end
end
