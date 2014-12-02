class Bridesmaid::ProductDetailsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def show
    require_user_logged_in!

    set_product_show_page_title(spree_product, selected_color.try(:presentation))
    display_marketing_banner

    @bridesmaid_user_profile = bridesmaid_user_profile

    #@recommended_products = get_recommended_products(spree_product, limit: 4)

    @product = product_details_resource.read
  end

  private

    # params parsers
    def spree_product
      @spree_product ||= begin
        product_id = params[:product_slug].match(/(\d)+$/)[0]
        Spree::Product.find(product_id)
      end
    end

    def selected_color
      return nil if params[:color_name].blank?
      @selected_color ||= Spree::OptionValue.colors.find_by_name!(params[:color_name])
    end

    def moodboard_owner
      @moodboard_owner ||= begin
        params[:user_slug].present? ? Spree::User.where(slug: params[:user_slug]).first : nil
      end
    end

    def product_details_resource
      Bridesmaid::ProductDetailsResource.new(
        site_version: current_site_version,
        product: spree_product,
        accessor: current_spree_user,
        moodboard_owner: moodboard_owner,
        selected_color: selected_color
      )
    end
end
