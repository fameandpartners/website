module Products
  class ColorVariantESIndexer
    class Helpers
      include ApplicationHelper
      include PathBuildeersHelper
    end

    def self.index!

    end


    private

    def self.build_variants
      helpers = Helpers.new
      au_site_version = SiteVersion.find_by_permalink('au')
      us_site_version = SiteVersion.find_by_permalink('us')

      color_variant_id = 1
      product_index = 1

      product_count = product_scope.count
    end

    def product_scope
      Spree::Product.active
    end
  end
end
