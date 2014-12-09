class Bridesmaid::ProductDetailsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def show
    require_user_logged_in!

    @product = product_details_resource.read

    set_product_show_page_title(spree_product, @product.selected_color.presentation)
    display_marketing_banner

    @bridesmaid_user_profile = bridesmaid_user_profile
    show_bridesmaid_header unless @bridesmaid_user_profile.owned_by?(current_spree_user)

    #@recommended_products = get_recommended_products(spree_product, limit: 4)
  end

  private

    def bridesmaid_user_profile
      @bridesmaid_user_profile ||= begin
        event = BridesmaidParty::Event.where(spree_user_id: moodboard_owner.id).first_or_initialize
        event
      end
    end

    def check_availability!
      available = bridesmaid_user_profile.members.where(spree_user_id: current_spree_user.id).exists?
      Bridesmaid::Errors::MoodboardAccessDenied if not available
      true
    end

    # params parsers
    def spree_product
      @spree_product ||= begin
        product_id = params[:product_slug].match(/(\d)+$/)[0]
        Spree::Product.find(product_id)
      end
    end

    def product_details_resource
      Bridesmaid::ProductDetailsResource.new(
        site_version: current_site_version,
        product: spree_product,
        accessor: current_spree_user,
        moodboard_owner: moodboard_owner,
        color_name: params[:color_name]
      )
    end
end
