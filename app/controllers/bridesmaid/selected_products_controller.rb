class Bridesmaid::SelectedProductsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!
  respond_to :json

  def update
    Bridesmaid::SelectedProduct.new(
      accessor: current_spree_user,
      moodboard_owner: moodboard_owner,
      product: spree_product,
      site_version: current_site_version,
      variant_id: params[:id],
      color: color,
      size: size,
      customizations: params[:customization_value_ids]
    ).update

    render json: {}, status: :ok
  rescue
    render json: {}, status: :error
  end

  # bride can move this item to cart
  def add_to_cart
    service = Bridesmaid::AddDressSelectedByBridesmaidToCart.new(
      site_version: current_site_version,
      accessor: current_spree_user,
      cart: current_order(true),
      membership_id: params[:id],
      promotion: current_promotion
    )
    product = service.process

    current_order.reload

    respond_to do |format|
      format.html { redirect_to(wishlist_path) }
      format.json {
        render json: {
          order: CartSerializer.new(current_order).to_json,
          analytics_label: analytics_label(:product, product)
        }
      }
    end
  rescue Exception => e
    raise e if Rails.env.development?
    respond_to do |format|
      format.html { redirect_to(wishlist_path) }
      format.json {
        render json: {}, status: :error
      }
    end
  end

  private

    # params parsers
    def spree_product
      @spree_product ||= begin
        product_id = params[:product_slug].match(/(\d)+$/)[0]
        Spree::Product.find(product_id)
      end
    end

    def color
      Spree::Variant.color_option_type.option_values.where(name: params[:color]).first
    end

    def size
      Spree::Variant.size_option_type.option_values.where(name: params[:size]).first
    end
end
