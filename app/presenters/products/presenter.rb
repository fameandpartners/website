module Products
  class Presenter < OpenStruct

    def default_color_options
      if colors? && colors.default.any?        
        colors.default.collect { |c| {id: c.id, name: c.name, display: c.presentation}  }   
      else
        []
      end
    end

    def custom_color_options
      if colors? && colors.extra.any?
        price = colors.default_extra_price.display_price 
        colors.extra.collect { |c| {id: c.id, name: c.name, display: c.presentation, price: price} }   
      else
        []
      end
    end

    def colors?
      colors.present?  || colors.extra.any?
    end

    def colors
      @colors = available_options.colors
    end

    def customization_options
      if customizable?
        customizations.all.collect { |c| {id: c.id, name: c.name, price: c.display_price.to_s} }   
      else
        []
      end
    end

    def all_images
      images.collect do |img | 
        { id: img.id, url: img.original, color_id: img.color_id, alt: name }
      end
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
      [ 
       moodboard.items.slice(0,2),
       moodboard.items.slice(2,2)
      ].compact      
    end

    def preorder?
      preorder.present? && preorder.downcase == "yes"
    end

    def customizable?
      customizations.present? && customizations.all.any?
    end

    def customizations
      @customizations ||= available_options.customizations
    end

  end
end