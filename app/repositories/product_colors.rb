# usage:
# Repositories::ProductColors.read_all
# Repositories::ProductColors.read(id)
# Repositories::ProductColors.get_by_name(name)
# Repositories::ProductColors.get_similar(color_ids, [0..100]
#
# Repositories::ProductColors.color_groups
# Repositories::ProductColors.get_group_by_name(name)

module Repositories
  class ProductColors
    class << self
      def colors_map
        @colors_map = begin
          Rails.cache.fetch("colors_map") do
            Spree::OptionType.color.option_values.inject({}) do |result, option_value|
              result[option_value.id] = {
                id: option_value.id,
                name: option_value.name,
                presentation: option_value.presentation,
                value: option_value.value,
                use_in_customisation: option_value.use_in_customisation,
                image: option_value.image? ? option_value.image.url(:small_square) : nil,
                image_file_name: option_value.image_file_name_for_swatches

              }
              result
            end
          end
        end
      end

      def color_groups
        @color_groups = begin
          Rails.cache.fetch("color_groups") do
            Spree::OptionType.color.option_values_groups.includes(:option_values).map do |group|
              color_ids = group.option_values.map(&:id)

              representative = \
                if color_ids.size == 1
                  Repositories::ProductColors.read(color_ids.first)
                else
                  { name: group.name, presentation: group.name }
                end

              {
                id: group.id,
                name: group.name.to_s.downcase,
                presentation: group.presentation,
                color_ids: color_ids,
                representative: representative
              }
            end
          end
        end
      end

      # colors guarantee will be reloaded after restart... we can live with that
      def read_all
        colors_map.values.clone.sort_by { |color| color[:name] }
      end

      def read(id, product_id = nil)
        if id.present?
          result = colors_map[id.to_i]&.clone
          # added this to get the real value for custom colors...not the fake one
          if product_id.present?
            pcv = ProductColorValue.where(product_id: product_id, option_value_id: id).first
            result[:custom_color] = pcv&.custom
          end
          result
        end
      end

      def get_by_name(color_name = nil)
        result = Array.wrap(color_name).compact.map do |c|
          color_name = c.to_s.downcase
          read_all.find{|color| color[:name].downcase == color_name || color[:presentation].downcase == color_name}
        end
        result.size < 2 ? result.first : result
      end

      def get_similar(color_ids, range = nil)
        range = Similarity::Range::DEFAULT if range < 0 or range > 100
        Similarity.where(original_id: color_ids).where('coefficient <= ?', range).pluck(:similar_id)
      end

      # groups
      def get_group_by_name(name)
        if name.present?
          group_name = name.to_s.downcase
          color_groups.find{|group| group[:name] == group_name }.try(:clone)
        end
      end

    end
  end
end
