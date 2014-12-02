class Bridesmaid::SelectedProductsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!
  respond_to :json

  def update
    Bridesmaid::SelectedProduct.new(
      accessor: current_spree_user,
      moodboard_owner: moodboard_owner,
      product: spree_product,
      variant_id: params[:id],
      color: color,
      size: size
    ).update

    render json: {}, status: :ok
  #rescue
  #  render json: {}, status: :error
  end

  private

    # params parsers
    def spree_product
      @spree_product ||= begin
        product_id = params[:product_slug].match(/(\d)+$/)[0]
        Spree::Product.find(product_id)
      end
    end

    def moodboard_owner
      @moodboard_owner ||= begin
        params[:user_slug].present? ? Spree::User.where(slug: params[:user_slug]).first : nil
      end
    end

    def color
      Spree::Variant.color_option_type.option_values.where(name: params[:color]).first
    end

    def size
      Spree::Variant.size_option_type.option_values.where(name: params[:size]).first
    end
end
