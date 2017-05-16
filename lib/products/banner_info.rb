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
      info[:footer_text] =  get_footer_text

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

      if selected_edits_taxons.count > 0
        from_taxon(selected_edits_taxons.first)
      elsif selected_collection_taxons.count > 0
        from_taxon(selected_collection_taxons.first)
      elsif selected_edits_taxons.count == 0 and selected_collection_taxons.count == 0
        from_taxon(root_range_taxon)
      else
        default_collections_info
      end
    end

    def get_page_title
      if @searcher.discount.present?
        if @searcher.discount == :all
          return "All Dresses on Sale | Fame and Partners"
        else
          return "Sale #{ @searcher.discount }% Off | Fame and Partners"
        end
      end

      #mind the spaces in the constructed strings
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        color = "#{seo_colour.titleize } "
      end

      taxon = selected_categories.first

      t_root = ""
      t_root = taxon.parent.name if taxon.present?

      # if the all dresses page /dresses
      if !color.present? && !t_root.present?
        t_root = @root_range_taxon.name
        taxon = @root_range_taxon
      end

      if t_root == "Style"
        style = "#{taxon.name.titleize} " || ""
      end

      if t_root == "Event"
        event = "#{taxon.name.titleize} " || "Any event "
      end

      bodyshape = " for #{@searcher.properties[:bodyshape].first} body shapes" if @searcher.properties[:bodyshape].present?

      #r =  "#{event}fashion starts with Fame and Partners - shop and customize #{color}#{style}dresses#{bodyshape}"
      r = "Shop the latest #{color}#{style}#{event}Dresses#{bodyshape} | Fame and Partners"

      if taxon.present? && taxon.seo_title.present?
        return taxon.seo_title
      elsif taxon.present? && taxon.banner.present? && taxon.banner.title.present?
        return taxon.banner.title
      else
        return r.capitalize
      end
    end

    def get_page_meta_description
      if @searcher.discount.present?
        if @searcher.discount == :all
          return "View all dresses on sale"
        else
          return "View all dresses with #{ @searcher.discount }% off"
        end
      end

      #mind the spaces in the constructed strings!
      r = nil

      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        color = " #{seo_colour.titleize} "
      end

      taxon = selected_categories.first

      t_root = ""
      t_root = taxon.parent.name if taxon.present?

      # if the all dresses page /dresses
      if !color.present? && !t_root.present?
        t_root = @root_range_taxon.name
        taxon = @root_range_taxon
      end

      if t_root == "Style"
        style = " #{taxon.name.titleize} " || ""
      end

      if t_root == "Event"
        event = " #{taxon.name.titleize} " || "any event "
      end

      r =  "Shop and customize the best #{color}#{style}#{event}dress trends #{event}at Fame and Partners."

      if taxon.present? && taxon.meta_description.present?
        r = taxon.meta_description
      end

      if taxon.present? && taxon.banner.present? && taxon.banner.seo_description.present?
        r = taxon.banner.seo_description
      end

      return r
    end

    def get_banner_title(title)

      if @searcher.discount.present?
        if @searcher.discount == :all
          return "All Dresses on Sale"
        else
          return "Sale #{ @searcher.discount }% Off"
        end
      end

      #mind the spaces in the constructed strings!
      r = nil

      # The way titles should work:
      # Black prom dresses //colour
      # Black strapless formal dresses //colour + style
      # Black strapless homecoming dresses // colour + style + event
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        color = seo_colour
      else
        color = ""
      end


      taxon = selected_categories.first

      t_root = ""
      t_root = taxon.parent.name if taxon.present?

      # if the all dresses page /dresses
      if !color.present? && !t_root.present?
        t_root = @root_range_taxon.name
        taxon = @root_range_taxon
      end

      # strapless formal dresses // style
      # strapless homecoming dresss // style + event
      if t_root == "Style"
        style = taxon.name
      else
        style = ""
      end

      # homecoming dresses // event
      if t_root == "Event"
        event = taxon.name
      else
        event = ""
      end

      # ignore body shape for no, too much information in the title.
      #bodyshape = ", best for #{@searcher.properties[:bodyshape].first} body shapes" if @searcher.properties[:bodyshape].present?

      r =  "#{color} #{style} #{event} dresses"

      # Edits always take presedance over other titles
      if t_root == "Edits"
        return taxon.name.capitalize
      end

      if taxon.present? && taxon.banner.present? && taxon.banner.title.present?
        return taxon.banner.title
      else
        return r.capitalize
      end
    end

    def get_banner_text(text)
      if @searcher.discount.present?
        if @searcher.discount == :all
          return "View all dresses on sale"
        else
          return "View all dresses with #{ @searcher.discount }% off"
        end
      end

      if !text && available_formal_dresses_colours.include?(@searcher.seo_colour)
        I18n.t(:subtitle, scope: [:collection, :colors, @searcher.seo_colour.parameterize.underscore], default: text)
      else
        text
      end
    end

    def get_banner_image
      if available_formal_dresses_colours.include?(@searcher.seo_colour)
        return
      elsif selected_edits_taxons.count > 0
        taxon_image(selected_edits_taxons.first)
      elsif selected_collection_taxons.count > 0
        taxon_image(selected_collection_taxons.first)
      elsif selected_edits_taxons.count == 0 and selected_collection_taxons.count == 0
        taxon_image(root_range_taxon)
      else
        return
      end
    end

    def get_footer_text
      taxon = selected_categories.first

      # if the all dresses page /dresses
      if !taxon.present?
        taxon = @root_range_taxon
      end

      if taxon.present? && taxon.banner.present? && taxon.banner.footer_text.present?
        return taxon.banner.footer_text
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
          collection_ids << seo_collection
        end
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
        banner_title: "Fame and Partners Formal Dresses",
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
      return r
    end
  end
end
