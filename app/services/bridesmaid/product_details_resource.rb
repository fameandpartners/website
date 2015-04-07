class Bridesmaid::ProductDetailsResource
  attr_reader :site_version, :product, :accessor, :moodboard_owner, :color_name


  def initialize(options = {})
    @site_version     = options[:site_version]
    @product          = options[:product]
    @accessor         = options[:accessor]
    @moodboard_owner  = options[:moodboard_owner]
    @color_name       = options[:color_name]
  end

  def read
    apply_bridesmaid_restrictions(default_product_details)
  end

  private

    def default_product_details
      @product_details ||= begin
        ::Products::ProductDetailsResource.new(
          site_version: site_version,
          product: product,
          color_name: color_name
        ).read
      end
    end

    def apply_bridesmaid_restrictions(details)
      original_colors = details.colors
      details.colors = details.colors.select{|color| color_ids.include?(color[:id]) }
      details.extra_colors = details.extra_colors.select{|color| color_ids.include?(color[:id]) }
      details.variants = details.variants.select{|variant| color_ids.include?(variant[:color_id]) }
      details.path = product_path(details)

      # filter images, but ensure there are at least some images
      images_with_selected_colors = details.images.select{|image| image.color_id.nil? || color_ids.include?(image.color_id)}
      details.images = images_with_selected_colors if images_with_selected_colors.present?

      # filter selected color
      if !color_ids.include?(details.selected_color.id)
        if (image = details.images.first).present?
          details.selected_color = FastOpenStruct.new(
            id: image.color_id,
            name: image.color,
            presentation: image.color
          )
        else
          details.selected_color = FastOpenStruct.new({})
        end
      end

      details
    end

    def bridesmaid_party_event
      @bridesmaid_party_event ||= BridesmaidParty::Event.where(spree_user_id: moodboard_owner.id).first_or_initialize
    end

    def color_ids
      @color_ids ||= bridesmaid_party_event.color_ids
    end

    #'/moodboard/:user_slug/dress-:product_slug(/:color_name)'
    def product_path(product)
      path_parts = [site_version.permalink, 'bridesmaid-party', bridesmaid_party_event.spree_user.slug]
      path_parts.push(
        ['dress', product.name.parameterize, product.id].reject(&:blank?).join('-')
      )
      path_parts.push(product.selected_color.name) if product.selected_color.name.present?
      "/" + path_parts.join('/')
    end
end
