module Products

  class Presenter
    attr_accessor :id, :master_id, :sku, :name, :short_description, :description,
                  :permalink, :is_active, :images, :default_image, :price,
                  :discount, :recommended_products, :available_options, :preorder,
                  :moodboard, :fabric, :style_notes, :color_id, :color_name, :color,
                  :size_chart, :making_option_id, :fit, :size, :fast_making

    def initialize(opts)
      opts.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

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

    def size_chart_explanation
      case size_chart
        when '2014'
          'This dress follows our old measurements.'
        when '2015'
          'We have updated our sizing! This dress follows our new size chart.'
        else
          ''
      end
    end

    def size_chart_data
      SizeChart.chart(size_chart)
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

    def cropped_images
      @cropped_images ||= images.select{ |i| i.original.to_s.downcase.include?('crop') }
    end

    def song
      moodboard.song_item
    end

    def celebrity
      moodboard.celebrity_item
    end

    def inspiration
      moodboard.items
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

    def making_options
       available_options.making_options
    end

    def default_color
      if color = available_options.colors.default.first
        color.name
      end
    end

    def use_auto_discount!(auto_discount)
      self.discount = [self.discount, auto_discount].compact.max_by{|i| i.amount.to_i }
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
