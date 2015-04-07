module Products
  class Presenter < FastOpenStruct

    def default_color_options
      if colors? && colors.default.any?        
        colors.default
      else
        []
      end
    end

    def custom_color_options
      if colors? && colors.extra.any?
        colors.extra
      else
        []
      end
    end

    def custom_color_price
      colors.default_extra_price.display_price 
    end

    def colors?
      colors.present?  || colors.extra.any?
    end

    def one_color?
      default_color_options.length == 1
    end

    def custom_colors?
      customisation_allowed? && colors.extra.any?
    end

    def colors
      @colors = available_options.colors
    end

    def default_sizes
      sizes.default
    end

    def default_sizes?
      default_sizes.any?
    end

    def custom_sizes
      sizes.extra
    end

    def custom_sizes?
      sizes.extra.any?
    end

    def custom_size_price
      sizes.default_extra_price.display_price
    end

    def sizes
      @sizes ||= available_options.sizes
    end

    def customization_options
      customizable? ? customizations.all : []
    end

    def all_images
      featured_images.collect do |img | 
        { id: img.id, url: img.original, color_id: img.color_id, alt: name }
      end
    end

    def featured_image
      @featured_image ||= featured_image_for_selected_color
    end

    def featured_image_for_selected_color
      color_image = images.select{ |i| i.color_id.to_i == color_id.to_i }.first
      color_image || featured_images.first      
    end

    # featured images are not cropped
    def featured_images
      @featured_images ||= images.select{ |i| ! i.original.to_s.downcase.include?('crop') }
    end

    def song
      moodboard.song_item
    end

    def celebrity
      moodboard.celebrity_item
    end

    # inspiration board has following layout:
    #  [ song  | item | item ]
    #  [ celeb | item | item ]
    def inspiration
      result = [ 
       moodboard.items.slice(0,2) || [],
       moodboard.items.slice(2,2) || []
      ].compact
      # fill to have exactly two items in row
      result[0] += Array.new(2 - result[0].size)
      result[1] += Array.new(2 - result[1].size)
      result
    end

    def preorder?
      preorder.present? && preorder.downcase == "yes"
    end

    def customizable?
      customisation_allowed? && customizations.present? && customizations.all.any?
    end

    def customizations
      @customizations ||= available_options.customizations
    end

    private

    def customisation_allowed?
      policy.customisation_allowed?
    end

    def policy
      @policy ||= Policy::Product.new(self)
    end
  end
end
