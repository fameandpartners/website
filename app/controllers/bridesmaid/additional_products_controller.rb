class Bridesmaid::AdditionalProductsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  # this page should be not shown. left to support stored elements
  def new
    raise Bridesmaid::Errors::ConsiergeServiceStepDisabled

    set_page_titles
    @product = consierge_service
  end

  # add consierge service
  def create
    line_item = add_product_to_user_cart(consierge_service)
    store_product_added(:consierge_service, line_item, params[:user_info])

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

      line_item = current_order.line_items.where(variant_id: product_variant.id).first_or_initialize
      line_item.quantity = 1
      line_item.currency = current_currency || cart.currency
      
      price = product_variant.zone_price_for(current_site_version.zone)
      if product_variant.in_sale?
        line_item.price = price.apply(variant.discount).amount
        line_item.old_price = price.amount
      else
        line_item.price = price.amount
      end

      line_item.save!

      cart.reload

      line_item
    end

    #def store_product_added(:consierge_service, line_item, params[:user_info])
    #{user_info: {phone: u_phone, email: u_email, suburb_state: u_suburb_state}}
    def store_product_added(name, line_item, args = {})
      additional_products = (bridesmaid_user_profile.additional_products || [])
      additional_products.delete_if{|record| !record.kind_of?(Hash)}

      product_details = additional_products.find{|record| record[:name] == name } || { name: name }
      additional_products.delete_if{|record| record[:name] == name }

      product_details[:line_item_id] = line_item.id
      product_details[:phone] = args[:phone] if args[:phone].present?
      product_details[:email] = args[:email] if args[:email].present?
      product_details[:suburb_state] = args[:suburb_state] if args[:suburb_state].present?

      additional_products.push(product_details)
      bridesmaid_user_profile.additional_products = additional_products
      bridesmaid_user_profile.save
    end
end
