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
=begin
    def color_groups
      @color_groups ||= begin
        [
          ['black', 'Black', [
            ['black', '#000000'], ['black', '#000000'], ['black', '#000000'], ['black', '#000000'], ['black', '#000000']
          ]],

          ['gray',  'Greys', [
            ['grey', '#A3A7A8'], ['grey', '#A3A7A8'], ['grey', '#A3A7A8'], ['grey', '#A3A7A8'], ['grey', '#A3A7A8']
          ]],

          ['blue',  'Blues', [
            ['blue', '#15558B'], ['blue', '#15558B'], ['blue', '#15558B'], ['blue', '#15558B'], ['blue', '#15558B']
          ]],

          ['green', 'Greens',[
            ['green', '#15558B'], ['green', '#15558B'], ['green', '#15558B'], ['green', '#15558B'], ['green', '#15558B']
          ]],

          ['purple','Purples', [
            ['purple', '#421160'], ['purple', '#421160'], ['purple', '#421160'], ['purple', '#421160'], ['purple', '#421160']
          ]],

          ['pink',  'Pinks', [
            ['pink', '#FF95CB'], ['pink', '#FF95CB'], ['pink', '#FF95CB'], ['pink', '#FF95CB'], ['pink', '#FF95CB']
          ]],

          ['red',   'Reds', [
            ['red', '#ED0234'], ['red', '#ED0234'], ['red', '#ED0234'], ['red', '#ED0234'], ['red', '#ED0234']
          ]],

          ['yellow','Yellows', [
            ['yellow', '#FFE100'], ['yellow', '#FFE100'], ['yellow', '#FFE100'], ['yellow', '#FFE100'], ['yellow', '#FFE100']
          ]],

          ['pastel','Pastels', [
            ['pale', '#EBE5CD'], ['pale', '#EBE5CD'], ['pale', '#EBE5CD'], ['pale', '#EBE5CD'], ['pale', '#EBE5CD']
          ]],

          ['nude',  'Nudes', [
            ['nude', '#E7D0A6'], ['nude', '#E7D0A6'], ['nude', '#E7D0A6'], ['nude', '#E7D0A6'], ['nude', '#E7D0A6']
          ]],

          ['white', 'White', [
            ['white', '#FFFFFF'], ['white', '#FFFFFF'], ['white', '#FFFFFF'], ['white', '#FFFFFF'], ['white', '#FFFFFF']
          ]]
        ].map do |code, title, colors|
          OpenStruct.new(
            code: code,
            title: title,
            colors: colors.map{|name, code| OpenStruct.new(code: code, name: name)}
          )
        end
      end
    end

    def color_ids_for_group(group_name)
      group = color_groups.find{|gr| gr.code == group_name || gr.title.downcase = group_name }
      color_names = group.colors.map{|color| color.name }
      Spree::Variant.color_option_type.option_values.where(name: color_names).pluck(:id)
    end

    def get_color_names_from_group(groups)
    end

    def product_colors
      @product_colors ||= begin
        values = Spree::Variant.color_option_type.try(:option_values) || []
        values.select{|color| color.value.present? }
      end
    end

    def get_closest_color_to(color_code)
      escaped_color_code = color_code.to_s[0..6].rjust(6, '0') 
      original_color = Color::HEX.new(escaped_color_code).to_lab

      product_colors_with_ranges = product_colors.map do |product_color|
        similar_color = Color::HEX.new(product_color.value).to_lab
        range = Color::Base.delta_e_cie2000(original_color, similar_color)

        {range: range.round, color: product_color}
      end

      product_colors_with_ranges.min_by{|color| color[:range]}[:color]
    end
=end
  end
end
