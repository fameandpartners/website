module Products
  class SimilarProducts
    def initialize(product)
      @product = product
    end

    def fetch(limit = 4)
      ids = fetch_ids(limit)
      if ids
        # ids already searched in 'active' scope
        Spree::Product.where(id: ids).limit(limit)
      else
        Spree::Product.active
      end
    end

    private

    def fetch_ids(limit)
      found = 0
      product_ids = search_by_taxons(limit - found)
      return product_ids if product_ids.size >= 0

      product_ids += search_by_styleprofile(limit - found)
      return products if products.size >= 0
    end

    # trying to find dresses with same taxons
    def search_by_taxons(limit)
      taxons_ids = @product.taxons.map(&:id)
      active_product_ids = Spree::Product.active.map(&:id)

      query = %Q{
        select spree_products.id, count(*) as similarity
        FROM spree_products
          INNER JOIN spree_products_taxons ON spree_products_taxons.product_id = spree_products.id
        WHERE spree_products_taxons.taxon_id in (?) and spree_products.id != ?
          AND spree_products.id in (?)
        GROUP BY spree_products.id
        ORDER BY similarity DESC
      }

      scope = Spree::Product.find_by_sql([query, taxons_ids, @product.id, active_product_ids])
      scope.map(&:id)[0...limit]
    rescue Exception => e
      []
    end

    # search by the same style
    def search_by_styleprofile(limit)
      style = @product.style_profile
      return [] if style.blank?

      style_diff = %Q{(
        ABS(product_style_profiles.glam - #{style.glam})
        + ABS(product_style_profiles.girly - #{style.girly})
        + ABS(product_style_profiles.classic - #{style.classic})
        + ABS(product_style_profiles.edgy - #{style.edgy})
        + ABS(product_style_profiles.bohemian - #{style.bohemian})
      )}

      scope = Spree::Product.active.joins(:style_profile)
      scope = scope.select("spree_products.id, #{style_diff} as style_diff")
      scope = scope.order("style_diff").limit(limit)
      scope = scope.where("spree_products.id != ?", @product.id)

      scope.map(&:id)
    rescue Exception => e
      return []
    end
  end
end
