Spree::OptionType.class_eval do
  has_many :option_values_groups, class_name: 'Spree::OptionValuesGroup'

  class << self
    def color_scope
      where(name: 'dress-color')
    end

    def size_scope
      where(name: 'dress-size')
    end

    # I really dislike these class variable based memoised values,
    # but am leaving them in place, despite adding new scopes to contain the SQL.
    def color
      @color ||= color_scope.first
    end

    def size
      @size ||= size_scope.first
    end
  end
end
