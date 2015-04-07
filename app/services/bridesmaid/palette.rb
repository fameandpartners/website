class Bridesmaid::Palette
  class << self
    def get
      palette = FastOpenStruct.new(
        color_groups: color_groups
      )
    end

    def color_groups
      @color_groups ||= begin
        Spree::OptionValuesGroup.includes(:option_values).all.map do |option_value_group|
          FastOpenStruct.new(
            name: option_value_group.name,
            presentation: option_value_group.presentation,
            colors: option_value_group.option_values.map do |option_value|
              FastOpenStruct.new(
                id: option_value.id, 
                name: option_value.name,
                presentation: option_value.presentation,
                value: option_value.value
              )
            end
          )
        end
      end
    end

    def color_ids_for_group(group_name)
      group = color_groups.find{|gr| gr.name == group_name || gr.presentation.downcase == group_name }
      group.colors.map{|color| color.id }
    end
  end
end
