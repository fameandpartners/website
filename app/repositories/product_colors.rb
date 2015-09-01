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
        @colors_map ||= begin
          result = {}
          Spree::OptionValue::ProductColor.all.each do |option_value|
            result[option_value.id] = OpenStruct.new(
              id: option_value.id,
              name: option_value.name,
              presentation: option_value.presentation,
              value: option_value.value,
              use_in_customisation: option_value.use_in_customisation,
              image: option_value.image? ? option_value.image.url(:small_square) : nil
            )
          end
          result
        end
      end

      def color_groups
        @color_groups ||= begin
          Spree::OptionType.color.option_values_groups.includes(:option_values).map do |group|
            color_ids = group.option_values.map(&:id)
            if color_ids.size == 1
              representative = Repositories::ProductColors.read(color_ids.first)
            else
              representative = OpenStruct.new(name: group.name, presentation: group.name)
            end

            OpenStruct.new(
              id: group.id,
              name: group.name.to_s.downcase,
              presentation: group.presentation,
              color_ids: color_ids,
              representative: representative
            )
          end
        end
      end

      # colors guarantee will be reloaded after restart... we can live with that
      def read_all
        colors_map.values.clone.sort_by{ |s| s.name }
      end

      def read(id)
        return nil if id.blank?
        colors_map[id.to_i].try(:clone)
      end

      def get_by_name(color_name = nil)
        result = Array.wrap(color_name).compact.map do |c|
          color_name = c.to_s.downcase
          read_all.find{|color| color.name.downcase == color_name || color.presentation.downcase == color_name}
        end
        result.size < 2 ? result.first : result
      end

      def get_similar(color_ids, range = nil)
        range = Similarity::Range::DEFAULT if range < 0 or range > 100
        Similarity.where(original_id: color_ids).where('coefficient <= ?', range).pluck(:similar_id)
      end

      # groups
      def get_group_by_name(name)
        nil if name.blank?
        group_name = name.to_s.downcase
        color_groups.find{|group| group.name == group_name }.try(:clone)
      end
    end
  end
end
