module Products
  class BannerInfo
    def initialize(searcher)
      @collection = searcher.collection || []
      @searcher = searcher
    end

    def available_formal_dresses_colours
      colors = %w{black red pink blue green coral turquoise gold peach teal champagne blush coral turquoise teal neon}
      colors + ['light blue', 'black and white']
    end

    def default_seo_title
      if Spree::Config[:default_seo_title].present? 
        Spree::Config[:default_seo_title]
      else
        "Prom Dresses"
      end
    end

    def default_meta_description
      if Spree::Config[:default_meta_description].present?
        Spree::Config[:default_meta_description]
      else
        "The latest catwalk and red carpet trends... crafted just for you."
      end
    end

    # in result, we should receive following
    #  {
    #    page_title
    #    meta_description
    #    banner_image
    #    banner_title
    #    banner_text
    #    category_description
    #    footer_text
    #  }
    def get
      info = get_info_by_taxons

      info[:page_title] = get_page_title
      info[:meta_description] = get_page_meta_description
      info[:banner_title] = get_banner_title(info[:banner_title])
      info[:banner_text] = get_banner_text(info[:banner_text])
      info[:banner_image] = get_banner_image

      info
    end

    # this returns
    #  {
    #    :banner_image
    #    :banner_title
    #    :banner_text
    #    :footer_text
    #    :category_description
    #  }
    def get_info_by_taxons
      if selected_edits_taxons.count == 1
        from_taxon(selected_edits_taxons.first)
      elsif selected_collection_taxons.count == 1
        from_taxon(selected_collection_taxons.first)
      elsif selected_edits_taxons.count == 0 and selected_collection_taxons.count == 0
        from_taxon(root_range_taxon)
      else
        default_collections_info
      end
    end

    def get_page_title
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        "#{seo_colour} Dresses, #{seo_colour} Evening Dresses Online, Prom and Formals - Fame & Partners"
      elsif selected_edits_taxons.count == 1
        taxon = selected_edits_taxons.first
        taxon.meta_title || [taxon.name, default_seo_title].join(' - ')
      elsif selected_collection_taxons.count == 1
        taxon = selected_collection_taxons.first
        taxon.meta_title || [taxon.name, default_seo_title].join(' - ')
      else
        default_seo_title
      end
    end

    def get_page_meta_description
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        "Fame & Partners stock a wide range of #{seo_colour} dresses online for all occasions, visit our store today."
      elsif selected_edits_taxons.count == 1
        taxon = selected_edits_taxons.first
        taxon.meta_description || [taxon.name, default_meta_description].join(' - ')
      elsif selected_collection_taxons.count == 1
        taxon = selected_collection_taxons.first
        taxon.meta_description || [taxon.name, default_meta_description].join(' - ')
      else
        default_meta_description
      end
    end

    def get_banner_title(title)
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        I18n.t(:title, scope: [:collection, :colors, @searcher.seo_colour.parameterize.underscore], default: "#{seo_colour} Dresses")
      elsif title.to_s.downcase == 'range'
        'Prom Dresses'
      else
        title
      end
    end

    def get_banner_text(text)
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        I18n.t(:subtitle, scope: [:collection, :colors, @searcher.seo_colour.parameterize.underscore], default: text)
      else
        text
      end
    end

    def get_banner_image
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        return
      elsif selected_edits_taxons.count == 1
        taxon_image(selected_edits_taxons.first)
      elsif selected_collection_taxons.count == 1
        taxon_image(selected_collection_taxons.first)
      elsif selected_edits_taxons.count == 0 and selected_collection_taxons.count == 0
        taxon_image(root_range_taxon)
      else
        return
      end
    end

    

    private

    def seo_colour
      @searcher.seo_colour.to_s.split(' ').map(&:capitalize).join(' ')
    rescue
      @searcher.seo_colour
    end

    def selected_collection_taxons
      @selected_collection ||= begin
        collection_ids = @searcher.collection
        seo_collection = @searcher.seocollection rescue []
        if seo_collection.present?
          collection_ids += seo_collection
        end
        selected_taxons(collection_ids, false)
      end
    end

    def selected_edits_taxons
      @selected_edits ||= selected_taxons(@searcher.edits, false)
    end

    def selected_taxons(taxon_ids, with_banner = false)
      if taxon_ids.blank?
        []
      else
        if with_banner
          Spree::Taxon.join(:banner).where(id: taxon_ids).to_a
        else
          Spree::Taxon.where(id: taxon_ids)
        end
      end
    end

    def root_range_taxon
      @root_range_taxon ||= Spree::Taxonomy.where(name: 'Range').first.root
    end

    def taxon_image(taxon)
      taxon.try(:banner).try(:image).present? ? taxon.banner.image.url(:banner) : nil
    end

    def default_collections_info
      {
        banner_image: taxon_image(root_range_taxon),
        banner_title: "Fame & Partners Formal Dresses",
        banner_text: "High fashion dresses."
      }
    end

    def from_taxon(taxon)
      {
        banner_image: taxon_image(taxon) || taxon_image(root_range_taxon),
        banner_title: taxon.try(:banner).try(:title) || taxon.name,
        banner_text: taxon.try(:banner).try(:description) || default_collections_info[:description],
        footer_text: taxon.try(:banner).try(:footer_text),
        category_description: taxon.try(:banner).try(:seo_description)
      }
    end
  end
end
