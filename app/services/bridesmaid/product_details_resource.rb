class Bridesmaid::ProductDetailsResource
  attr_reader :site_version, :product, :accessor, :moodboard_owner, :selected_color


  def initialize(options = {})
    @site_version     = options[:site_version]
    @product          = options[:product]
    @accessor         = options[:accessor]
    @moodboard_owner  = options[:moodboard_owner]
    @selected_color   = options[:selected_color]
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
          selected_color: selected_color
        ).read
      end
    end

    def bridesmaid_party_event
      @bridesmaid_party_event ||= BridesmaidParty::Event.where(spree_user_id: moodboard_owner.id).first_or_initialize
    end

    def color_ids
      @color_ids ||= begin
        color_ids = bridesmaid_party_event.colors.map{|c| c[:id]}
        similar_color_ids = Similarity.get_similar_color_ids(color_ids, Similarity::Range::VERY_CLOSE)
        color_ids + similar_color_ids
      end
    end

    def apply_bridesmaid_restrictions(details)
      details.colors = details.colors.select{|color| color_ids.include?(color[:id]) }
      details.extra_colors = details.extra_colors.select{|color| color_ids.include?(color[:id]) }
      details.variants = details.variants.select{|variant| color_ids.include?(variant[:color_id]) }

      details
    end
end
