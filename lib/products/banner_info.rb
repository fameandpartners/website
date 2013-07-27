module Products
  class BannerInfo
    def initialize(taxon_ids = [])
      @taxon_ids = taxon_ids || []
    end

    def get
      if selected_taxons.count == 0
        from_taxon(root_range_taxon)
      elsif selected_taxons.count == 1
        from_taxon(selected_taxons.first)
      else
        multiple_collections_info
      end
    end

    private

    def selected_taxons
      @selected_taxons ||= begin
        if @taxon_ids.blank?
          []
        else
          Spree::Taxon.where(id: @taxon_ids)
        end
      end
    end

    def root_range_taxon
      @root_range_taxon ||= Spree::Taxonomy.where(name: 'Range').first.root
    end

    def taxon_image(taxon)
      image = taxon.banner.image.present? ? taxon.banner.image.url(:banner) : nil
    end

    def multiple_collections_info
      { 
        image: taxon_image(root_range_taxon),
        title: "Fame & Partners Formal Dresses",
        description: "High fashion dresses."
      }
    end

    def from_taxon(taxon)
      {
        image: taxon_image(taxon) || taxon_image(root_range_taxon),
        title: taxon.banner.title || taxon.title,
        description: taxon.banner.description || multiple_collections_info[:description]
      }
    end
  end
end
