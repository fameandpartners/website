module Products
  class BannerInfo
    def initialize(searcher)
      @collection = searcher.collection || []
      @searcher = searcher
    end

    def available_formal_dresses_colours
      colors = %w{pastel black red pink blue green coral turquoise gold peach teal champagne blush coral turquoise teal neon}
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
      #mind the spaces in the constructed strings
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        color = "#{seo_colour} "
      end

      
      taxon = selected_categories.first

      
      t_root = ""
      t_root = taxon.parent.name if taxon.present?

      if t_root == "Style"
        style = "#{taxon.name} " || ""
      end

      if t_root == "Event"
        event = "#{taxon.name} " || "Any event "
      end

      bodyshape = " for #{@searcher.properties[:bodyshape].first} body shapes" if @searcher.properties[:bodyshape].present?

      r =  "#{event}fashion starts with Fame & Partners - shop and customize #{color}#{style}dresses#{bodyshape}"

      return r.capitalize
    end

    def get_page_meta_description
      #mind the spaces in the constructed strings!
      r = nil

      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        color = " #{seo_colour} "
      end

      
      taxon = selected_categories.first

      
      t_root = ""
      t_root = taxon.parent.name if taxon.present?

      if t_root == "Style"
        style = " #{taxon.name} " || ""
      end

      if t_root == "Event"
        event = "for your #{taxon.name} " || "Any event "
      end

      r =  "Shop and customize the best of#{color}dress trends #{event}at Fame & Partners"

      return r.capitalize
    end

    def get_banner_title(title)
      #mind the spaces in the constructed strings!
      r = nil

      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        color = " #{seo_colour} dresses "
      else
        color = ""
      end

      
      taxon = selected_categories.first

      
      t_root = ""
      t_root = taxon.parent.name if taxon.present?

      if t_root == "Style"
        style = " #{taxon.name}"
      else
        style = "in a variety of styles"
      end

      if t_root == "Event"
        event = "#{taxon.name} "
      else
        event = "Formal "
      end

      bodyshape = ", best for #{@searcher.properties[:bodyshape].first} body shapes" if @searcher.properties[:bodyshape].present?

      r =  "#{event}Dresses:#{color}#{style}#{bodyshape}"

      return r.capitalize
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
        collection_ids = @searcher.selected_taxons
        seo_collection = @searcher.seocollection rescue []
        if seo_collection.present?
          collection_ids += seo_collection
        end
        #binding.pry
        selected_taxons(collection_ids, false)
      end
    end

    def selected_edits_taxons
      @selected_edits ||= selected_taxons(@searcher.selected_edits, false)
    end

    def selected_categories
      selected_collection_taxons.concat(@selected_edits)
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
      r ={
        banner_image: taxon_image(taxon) || taxon_image(root_range_taxon),
        banner_title: taxon.try(:banner).try(:title) || taxon.name,
        banner_text: taxon.try(:banner).try(:description) || default_collections_info[:description],
        footer_text: taxon.try(:banner).try(:footer_text),
        category_description: taxon.try(:banner).try(:seo_description)
      }
      #binding.pry
      return r
    end
  end
end
