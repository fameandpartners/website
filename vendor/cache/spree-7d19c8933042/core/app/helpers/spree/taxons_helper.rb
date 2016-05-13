module Spree
  module TaxonsHelper
    # Retrieves the collection of products to display when "previewing" a taxon.  This is abstracted into a helper so
    # that we can use configurations as well as make it easier for end users to override this determination.  One idea is
    # to show the most popular products for a particular taxon (that is an exercise left to the developer.)
    def taxon_preview(taxon, max=4)
      products = taxon.active_products.limit(max)
      if (products.size < max) && Spree::Config[:show_descendents]
        taxon.descendants.each do |taxon|
          to_get = max - products.length
          products += taxon.active_products.limit(to_get)
          products = products.uniq
          break if products.size >= max
        end
      end
      products
    end
  end
end
