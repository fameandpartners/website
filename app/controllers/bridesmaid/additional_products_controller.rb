class Bridesmaid::AdditionalProductsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def new
    set_page_titles
    @product = consierge_service
  end

  # add consierge service
  def create
    add_product_to_user_cart(consierge_service)
    store_product_added(:consierge_service)

    respond_to do |format|
      format.html do
        redirect_to(bridesmaid_party_dresses_path)
      end
      format.json do
        render json: {
          order: CartSerializer.new(current_order).to_json,
          analytics_label: analytics_label(:product, consierge_service)
        }
      end
    end
  end

  private

    def consierge_service
      @consierge_service ||= begin
        variant = Spree::Variant.where(sku: 'ap10001cs').includes(:product).first
        if variant.blank?
          raise Bridesmaid::Errors::ConsiergeServiceNotFound
        else
          variant
        end
      end
    end

    # user, product, currency
    def add_product_to_user_cart(product_variant)
      cart = current_order(true)
      currency = current_currency || cart.currency

      price = product_variant.price_in(currency)

      line_item = current_order.line_items.where(variant_id: product_variant.id).first_or_initialize
      line_item.quantity     = 1
      line_item.currency     = current_currency
      line_item.price        = price.final_amount(is_surryhills = false)

      if product_variant.in_sale?
        line_item.old_price = price.amount_without_discount
      end

      line_item.save!

      cart.reload

      cart
    end

    def store_product_added(name)
      bridesmaid_user_profile.additional_products ||= []
      bridesmaid_user_profile.additional_products.push(name.to_sym).uniq!
      bridesmaid_user_profile.save
    end
end
