Spree::Variant.class_eval do
  def dress_color
    get_option_value(self.class.color_option_type)
  end

  def dress_size
    get_option_value(self.class.size_option_type)
  end

  def get_option_value(option_type)
    return nil unless option_type
    self.option_values.detect do |option|
      option.option_type_id == option_type.id
    end
  end

  class << self
    def size_option_type
      @size_option_type ||= Spree::OptionType.where(name: 'dress-size').first
    end

    def color_option_type
      @color_option_type ||= Spree::OptionType.where(name: 'dress-color').first
    end
  end
end
