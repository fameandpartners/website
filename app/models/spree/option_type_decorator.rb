Spree::OptionType.class_eval do
  class << self
    def color
      @color ||= where(name: 'dress-color').first
    end
  end
end
