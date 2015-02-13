# usage:
# Repositories::ProductColors.read_all
# Repositories::ProductColors.get_by_name
# Repositories::ProductColors.get_similar(color_ids, [0..100]

module Repositories
  class ProductColors
    class << self
      # colors guarantee will be reloaded after restart... we can live with that
      def read_all
        @colors ||= Spree::Variant.color_option_type.try(:option_values) || []
      end

      def get_by_name(color_name = nil)
        return nil if color_name.blank?
        color_name = color_name.to_s.downcase
        read_all.find{|color| color.name.downcase == color_name || color.presentation.downcase == color_name}
      end

      def get_similar(color_ids, range = nil)
        range = Similarity::Range::DEFAULT if range < 0 or range > 100
        Similarity.where(original_id: color_ids).where('coefficient <= ?', range).pluck(:similar_id)
      end
    end
  end
end
